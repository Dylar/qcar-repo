package de.bitb.main_service.service.dealer

import de.bitb.main_service.builder.buildInvalidSaleInfo
import de.bitb.main_service.builder.buildSaleInfo
import de.bitb.main_service.datasource.dealer.SaleInfoDataSource
import de.bitb.main_service.exceptions.SaleInfoException
import de.bitb.main_service.models.SaleInfo
import de.bitb.main_service.service.DealerInfoService
import io.mockk.every
import io.mockk.mockk
import io.mockk.slot
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class SaleServiceTest {

    private lateinit var dataSource: SaleInfoDataSource
    private lateinit var service: DealerInfoService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getSaleInfo(any()) }.returns(null)
        service = DealerInfoService(
            mockk(relaxed = true),
            mockk(relaxed = true),
            mockk(relaxed = true),
            dataSource,
            mockk(relaxed = true),
        )
    }

    @Test
    fun `get sale from service`() {
        //given
        val testInfo = buildSaleInfo()
        every { dataSource.getSaleInfo(testInfo.key) }
            .returns(testInfo)
        //when
        val info = service.getSaleInfo(testInfo.key)
        //then
        verify(exactly = 1) { dataSource.getSaleInfo(testInfo.key) }
        assertThat(info == testInfo)
    }

    @Test
    fun `get no sale from datasource - throw UnknownKeyException`() {
        //given
        val testInfo = buildSaleInfo()
        //when
        val exceptionNoInfo: Exception = assertThrows { service.getSaleInfo(testInfo.key) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is SaleInfoException.UnknownKeyException)
    }

    @Test
    fun `add sale to service - key added`() {
        //given
        val testInfo = buildSaleInfo().copy(key = "")
        //when
        service.addSaleInfo(testInfo)
        //then
        val slot = slot<SaleInfo>()

        verify(exactly = 1) { dataSource.addSaleInfo(capture(slot)) }

        val info = slot.captured
        assertThat(info.brand == testInfo.brand)
        assertThat(info.model == testInfo.model)
        assertThat(info.seller == testInfo.seller)
        assertThat(info.dealer == testInfo.dealer)
        assertThat(info.key != testInfo.key)
        assertThat(info.key.isNotBlank())
        assertThat(testInfo.key.isBlank())
    }


    @Test
    fun `try adding invalid sale - throw exceptions`() {
        var emptyInfo = buildInvalidSaleInfo()
        var exception: Exception = assertThrows { service.addSaleInfo(emptyInfo) }
        assertThat(exception is SaleInfoException.EmptyBrandException)

        emptyInfo = emptyInfo.copy(brand = "Toyota")
        exception = assertThrows { service.addSaleInfo(emptyInfo) }
        assertThat(exception is SaleInfoException.EmptyModelException)

        emptyInfo = emptyInfo.copy(model = "Corolla")
        exception = assertThrows { service.addSaleInfo(emptyInfo) }
        assertThat(exception is SaleInfoException.EmptySellerException)

        emptyInfo = emptyInfo.copy(seller = "Maxi")
        exception = assertThrows { service.addSaleInfo(emptyInfo) }
        assertThat(exception is SaleInfoException.EmptyDealerException)

        emptyInfo = emptyInfo.copy(dealer = "Hamburger Autos")
        exception = assertThrows { service.addSaleInfo(emptyInfo) }
        assertThat(exception is SaleInfoException.NotEmptyKeyException)

        emptyInfo = emptyInfo.copy(key = "")
        exception = assertThrows { service.addSaleInfo(emptyInfo) }
        assertThat(exception is SaleInfoException.EmptyIntroException)

        emptyInfo = emptyInfo.copy(intro = "path/to/file.mp3")
        exception = assertThrows { service.addSaleInfo(emptyInfo) }
        assertThat(exception is SaleInfoException.NoVideosException)

        emptyInfo = emptyInfo.copy(videos = mapOf("Sicherheit" to listOf()))
        exception = assertThrows { service.addSaleInfo(emptyInfo) }
        assertThat(exception is SaleInfoException.NoVideosForCategoryException)

        emptyInfo = emptyInfo.copy(videos = mapOf("Sicherheit" to listOf("Gurt")))
        service.addSaleInfo(emptyInfo)
        verify(exactly = 1) { dataSource.addSaleInfo(any()) }
    }

}