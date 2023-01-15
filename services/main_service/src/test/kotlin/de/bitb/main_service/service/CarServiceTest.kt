package de.bitb.main_service.service

import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.builder.buildEmptyCarInfo
import de.bitb.main_service.datasource.car.CarInfoDataSource
import de.bitb.main_service.datasource.dealer.CarLinkDataSource
import de.bitb.main_service.datasource.dealer.SellInfoDataSource
import de.bitb.main_service.exceptions.CarInfoException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import java.lang.Exception
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.*
import org.junit.jupiter.api.Assertions.assertEquals

internal class CarServiceTest {

    private lateinit var service: CarInfoService
    private lateinit var sellDataSource: SellInfoDataSource
    private lateinit var carDataSource: CarInfoDataSource

    @BeforeEach
    fun setUp() {
        carDataSource = mockk(relaxed = true)
        sellDataSource = mockk(relaxed = true)
        service = CarInfoService(carDataSource, sellDataSource)
    }

    @Test
    fun `get car from service`() {
        //given
        val testInfo = buildCarInfo()
        every { carDataSource.getCarInfo(testInfo.brand, testInfo.model) }.returns(testInfo)
        //when
        val info = service.getCarInfo(testInfo.brand, testInfo.model)
        //then
        verify(exactly = 1) { carDataSource.getCarInfo(testInfo.brand, testInfo.model) }
        assertEquals(info, testInfo)
    }

    @Test
    fun `get no car from datasource - throw UnknownCarException`() {
        //given
        every { carDataSource.getCarInfo(any(), any()) }.returns(null)
        val testInfo = buildCarInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getCarInfo(testInfo.brand, testInfo.model) }
        //then
        assertThat(exceptionNoInfo is CarInfoException.UnknownCarException)
    }

    @Test
    fun `add car to service`() {
        //given
        val testInfo = buildCarInfo()
        //when
        service.addCarInfo(testInfo)
        //then
        verify(exactly = 1) { carDataSource.addCarInfo(testInfo) }
    }

    @Test
    fun `try adding invalid car - throw exceptions`() {
        var emptyInfo = buildEmptyCarInfo()
        var exception: Exception = assertThrows { service.addCarInfo(emptyInfo) }
        assertThat(exception is CarInfoException.EmptyBrandException)

        emptyInfo = emptyInfo.copy(brand = "Brand")
        exception = assertThrows { service.addCarInfo(emptyInfo) }
        assertThat(exception is CarInfoException.EmptyModelException)

        emptyInfo = emptyInfo.copy(model = "model")
        exception = assertThrows { service.addCarInfo(emptyInfo) }
        assertThat(exception is CarInfoException.EmptyImagePathException)

        emptyInfo = emptyInfo.copy(imagePath = "path/to/file")
        service.addCarInfo(emptyInfo)
        verify(exactly = 1) { carDataSource.addCarInfo(emptyInfo) }
    }
}
