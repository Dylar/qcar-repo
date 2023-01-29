package de.bitb.main_service.service.dealer

import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.datasource.car.CarInfoDataSource
import de.bitb.main_service.datasource.dealer.CarLinkDataSource
import de.bitb.main_service.builder.buildEmptyCarLink
import de.bitb.main_service.builder.buildCarLink
import de.bitb.main_service.exceptions.CarLinkException
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

internal class CarLinkServiceTest {

    private lateinit var carDS: CarInfoDataSource
    private lateinit var carLinkDS: CarLinkDataSource
    private lateinit var service: DealerInfoService

    @BeforeEach
    fun setUp() {
        carDS = mockk(relaxed = true)
        carLinkDS = mockk(relaxed = true)
        every { carDS.getCarInfo(any(), any()) }.returns(null)
        every { carLinkDS.getLinks(any()) }.returns(null)
        service = DealerInfoService(
            mockk(relaxed = true),
            carLinkDS,
            mockk(relaxed = true),
            mockk(relaxed = true),
            carDS,
        )
    }

    @Test
    fun `get car link from service`() {
        //given
        val testLink = buildCarLink()
        val testCar = buildCarInfo()
        every { carDS.getCarInfo(testCar.brand, testCar.model) }.returns(testCar)
        every { carLinkDS.getLinks(testLink.dealer) }.returns(listOf(testLink))
        //when
        val cars = service.getCarInfos(testLink.dealer)
        //then
        assertThat(cars.size == 1)
        val car = cars.first()
        verify(exactly = 1) { carDS.getCarInfo(testCar.brand, testCar.model) }
        verify(exactly = 1) { carLinkDS.getLinks(testLink.dealer) }
        assertThat(car == testCar)
    }

    @Test
    fun `get no car link from datasource - throw UnknownCarLinkException`() {
        //given
        val testInfo = buildCarLink()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getCarInfos(testInfo.dealer) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is CarLinkException.NoCarLinksException)
    }

    @Test
    fun `try adding invalid car link - throw exceptions`() {
        var emptyInfo = buildEmptyCarLink()
        var exception: Exception = assertThrows { service.linkCarToDealer(emptyInfo) }
        assertThat(exception is CarLinkException.EmptyDealerException)

        emptyInfo = emptyInfo.copy(dealer = "Autohaus")
        exception = assertThrows { service.linkCarToDealer(emptyInfo) }
        assertThat(exception is CarLinkException.EmptyBrandException)

        emptyInfo = emptyInfo.copy(brand = "MuhCars")
        exception = assertThrows { service.linkCarToDealer(emptyInfo) }
        assertThat(exception is CarLinkException.EmptyModelException)

        emptyInfo = emptyInfo.copy(model = "MuhCar")
        service.linkCarToDealer(emptyInfo)
        verify(exactly = 1) { carLinkDS.addLink(any()) }
    }

}