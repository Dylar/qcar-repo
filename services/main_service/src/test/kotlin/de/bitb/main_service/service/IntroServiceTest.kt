package de.bitb.main_service.service

import de.bitb.main_service.builder.buildEmptyIntroInfo
import de.bitb.main_service.builder.buildIntroInfo
import de.bitb.main_service.datasource.intro_info.IntroInfoDataSource
import de.bitb.main_service.exceptions.IntroInfoException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class IntroServiceTest {

    private lateinit var dataSource: IntroInfoDataSource
    private lateinit var service: IntroInfoService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getIntroInfo(any(), any(), any(), any()) }.returns(null)
        service = IntroInfoService(dataSource)
    }

    @Test
    fun `get seller from service`() {
        //given
        val testInfo = buildIntroInfo()
        every {
            dataSource.getIntroInfo(
                testInfo.dealer, testInfo.seller,
                testInfo.brand,
                testInfo.model
            )
        }
            .returns(testInfo)
        //when
        val info =
            service.getIntroInfo(
                testInfo.dealer, testInfo.seller,
                testInfo.brand,
                testInfo.model
            )
        //then
        verify(exactly = 1) {
            dataSource.getIntroInfo(
                testInfo.dealer, testInfo.seller,
                testInfo.brand,
                testInfo.model
            )
        }
        assertThat(info == testInfo)
    }

    @Test
    fun `get no seller from datasource - throw UnknownIntroException`() {
        //given
        val testInfo = buildIntroInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getIntroInfo(testInfo.dealer, testInfo.seller,
                testInfo.brand,
                testInfo.model) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is IntroInfoException.UnknownIntroException)
    }

    @Test
    fun `try adding invalid seller - throw exceptions`() {
        var emptyInfo = buildEmptyIntroInfo()
        var exception: Exception = assertThrows { service.addIntroInfo(emptyInfo) }
        assertThat(exception is IntroInfoException.EmptyDealerException)

        emptyInfo = emptyInfo.copy(dealer = "Hamburger Autos")
        exception = assertThrows { service.addIntroInfo(emptyInfo) }
        assertThat(exception is IntroInfoException.EmptySellerException)

        emptyInfo = emptyInfo.copy(seller = "Maxi")
        exception = assertThrows { service.addIntroInfo(emptyInfo) }
        assertThat(exception is IntroInfoException.EmptyBrandException)

        emptyInfo = emptyInfo.copy(brand = "Toyota")
        exception = assertThrows { service.addIntroInfo(emptyInfo) }
        assertThat(exception is IntroInfoException.EmptyModelException)

        emptyInfo = emptyInfo.copy(model = "CorollaTSGR")
        exception = assertThrows { service.addIntroInfo(emptyInfo) }
        assertThat(exception is IntroInfoException.EmptyFilePathException)

        emptyInfo = emptyInfo.copy(filePath = "path/to/file.mp4")
        service.addIntroInfo(emptyInfo)
        verify(exactly = 1) { dataSource.addIntroInfo(any()) }
    }

}