package de.bitb.main_service.service

import de.bitb.main_service.builder.buildEmptySellerInfo
import de.bitb.main_service.builder.buildSellerInfo
import de.bitb.main_service.datasource.seller_info.SellerInfoDataSource
import de.bitb.main_service.exceptions.SellerInfoException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class SellerServiceTest {

    private lateinit var dataSource: SellerInfoDataSource
    private lateinit var service: SellerInfoService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getSellerInfo(any(), any()) }.returns(null)
        service = SellerInfoService(dataSource)
    }

    @Test
    fun `get seller from service`() {
        //given
        val testInfo = buildSellerInfo()
        every { dataSource.getSellerInfo(testInfo.dealer, testInfo.name) }
            .returns(testInfo)
        //when
        val info =
            service.getSellerInfo(testInfo.dealer, testInfo.name)
        //then
        verify(exactly = 1) { dataSource.getSellerInfo(testInfo.dealer, testInfo.name) }
        assertThat(info == testInfo)
    }

    @Test
    fun `get no seller from datasource - throw UnknownSellerException`() {
        //given
        val testInfo = buildSellerInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getSellerInfo(testInfo.dealer, testInfo.name) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is SellerInfoException.UnknownSellerException)
    }

    @Test
    fun `try adding invalid seller - throw exceptions`() {
        var emptyInfo = buildEmptySellerInfo()
        var exception: Exception = assertThrows { service.addSellerInfo(emptyInfo) }
        assertThat(exception is SellerInfoException.EmptySellerException)

        emptyInfo = emptyInfo.copy(name = "Maxi")
        exception = assertThrows { service.addSellerInfo(emptyInfo) }
        assertThat(exception is SellerInfoException.EmptyDealerException)

        emptyInfo = emptyInfo.copy(dealer = "Hamburger Autos")
        service.addSellerInfo(emptyInfo)
        verify(exactly = 1) { dataSource.addSellerInfo(any()) }
    }

}