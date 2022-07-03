package de.bitb.main_service.service

import de.bitb.main_service.builder.buildInvalidSellInfo
import de.bitb.main_service.builder.buildSellInfo
import de.bitb.main_service.builder.buildVideoInfo
import de.bitb.main_service.datasource.sell_info.SellInfoDataSource
import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.models.SellInfo
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

internal class SellServiceTest {

    private lateinit var dataSource: SellInfoDataSource
    private lateinit var service: SellInfoService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getSellInfo(any()) }.returns(null)
        service = SellInfoService(dataSource)
    }

    @Test
    fun `get sell from service`() {
        //given
        val testInfo = buildSellInfo()
        every { dataSource.getSellInfo(testInfo.key) }
            .returns(testInfo)
        //when
        val info =
            service.getSellInfo(testInfo.key)
        //then
        verify(exactly = 1) { dataSource.getSellInfo(testInfo.key) }
        assertThat(info == testInfo)
    }

    @Test
    fun `get no sell from datasource - throw UnknownKeyException`() {
        //given
        val testInfo = buildSellInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getSellInfo(testInfo.key) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is SellInfoException.UnknownKeyException)
    }

    @Test
    fun `add sell to service - key added`() {
        //given
        val testInfo = buildSellInfo().copy(key = "")
        //when
        service.addSellInfo(testInfo)
        //then
        val slot = slot<SellInfo>()

        verify(exactly = 1) { dataSource.addSellInfo(capture(slot)) }

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
    fun `try adding invalid sell - throw exceptions`() {
        var emptyInfo = buildInvalidSellInfo()
        var exception: Exception = assertThrows { service.addSellInfo(emptyInfo) }
        assertThat(exception is SellInfoException.EmptyBrandException)

        emptyInfo = emptyInfo.copy(brand = "Toyota")
        exception = assertThrows { service.addSellInfo(emptyInfo) }
        assertThat(exception is SellInfoException.EmptyModelException)

        emptyInfo = emptyInfo.copy(model = "Corolla")
        exception = assertThrows { service.addSellInfo(emptyInfo) }
        assertThat(exception is SellInfoException.EmptySellerException)

        emptyInfo = emptyInfo.copy(seller = "Maxi")
        exception = assertThrows { service.addSellInfo(emptyInfo) }
        assertThat(exception is SellInfoException.EmptyDealerException)

        emptyInfo = emptyInfo.copy(dealer = "Hamburger Autos")
        exception = assertThrows { service.addSellInfo(emptyInfo) }
        assertThat(exception is SellInfoException.NotEmptyKeyException)

        emptyInfo = emptyInfo.copy(key = "")
        exception = assertThrows { service.addSellInfo(emptyInfo) }
        assertThat(exception is SellInfoException.NoVideosException)

        emptyInfo = emptyInfo.copy(videos = mapOf("Sicherheit" to listOf()))
        exception = assertThrows { service.addSellInfo(emptyInfo) }
        assertThat(exception is SellInfoException.NoVideosForCategoryException)

        emptyInfo = emptyInfo.copy(videos = mapOf("Sicherheit" to listOf("Gurt")))
        service.addSellInfo(emptyInfo)
        verify(exactly = 1) { dataSource.addSellInfo(any()) }
    }

}