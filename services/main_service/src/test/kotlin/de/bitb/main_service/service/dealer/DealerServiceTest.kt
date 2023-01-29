package de.bitb.main_service.service.dealer

import de.bitb.main_service.builder.buildEmptyDealerInfo
import de.bitb.main_service.builder.buildDealerInfo
import de.bitb.main_service.datasource.dealer.DealerInfoDataSource
import de.bitb.main_service.exceptions.DealerInfoException
import de.bitb.main_service.service.DealerInfoService
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class DealerServiceTest {

    private lateinit var dataSource: DealerInfoDataSource
    private lateinit var service: DealerInfoService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getDealerInfo(any()) }.returns(null)
        service = DealerInfoService(
            dataSource,
            mockk(relaxed = true),
            mockk(relaxed = true),
            mockk(relaxed = true),
            mockk(relaxed = true),
        )
    }

    @Test
    fun `get dealer from service`() {
        //given
        val testInfo = buildDealerInfo()
        every { dataSource.getDealerInfo(testInfo.name) }.returns(testInfo)
        //when
        val info = service.getDealerInfo(testInfo.name)
        //then
        verify(exactly = 1) { dataSource.getDealerInfo(testInfo.name) }
        assertThat(info == testInfo)
    }

    @Test
    fun `get no dealer from datasource - throw UnknownDealerException`() {
        //given
        val testInfo = buildDealerInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getDealerInfo( testInfo.name) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is DealerInfoException.UnknownDealerException)
    }

    @Test
    fun `try adding invalid dealer - throw exceptions`() {
        var emptyInfo = buildEmptyDealerInfo()
        var exception: Exception = assertThrows { service.addDealerInfo(emptyInfo) }
        assertThat(exception is DealerInfoException.EmptyNameException)

        emptyInfo = emptyInfo.copy(name = "Autohaus")
        exception = assertThrows { service.addDealerInfo(emptyInfo) }
        assertThat(exception is DealerInfoException.EmptyAddressException)

        emptyInfo = emptyInfo.copy(address = "Hamburger Straße 42")
        service.addDealerInfo(emptyInfo)
        verify(exactly = 1) { dataSource.addDealerInfo(any()) }
    }

}