package de.bitb.main_service.service

import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.builder.buildEmptyCarInfo
import de.bitb.main_service.builder.buildTechInfo
import de.bitb.main_service.datasource.car_info.CarInfoDataSource
import de.bitb.main_service.datasource.sell_info.SellInfoDataSource
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.TechInfoException
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

        var emptyCarInfo = buildEmptyCarInfo()
        var exception: Exception = assertThrows { service.addCarInfo(emptyCarInfo) }
        assertThat(exception is CarInfoException.EmptyBrandException)

        emptyCarInfo = emptyCarInfo.copy(brand = "Brand")
        exception = assertThrows { service.addCarInfo(emptyCarInfo) }
        assertThat(exception is CarInfoException.EmptyModelException)

        emptyCarInfo = emptyCarInfo.copy(model = "model")
        exception = assertThrows { service.addCarInfo(emptyCarInfo) }
        assertThat(exception is CarInfoException.EmptyImagePathException)

        emptyCarInfo = emptyCarInfo.copy(imagePath = "path/to/file")
        service.addCarInfo(emptyCarInfo)
        verify(exactly = 1) { carDataSource.addCarInfo(emptyCarInfo) }
    }

    //TODO TECH outsourcen


    @Test
    fun `get tech from service`() {
        //given
        val testInfo = buildTechInfo()
        every { carDataSource.getTechInfo(testInfo.brand, testInfo.model) }.returns(testInfo)
        //when
        val info = service.getTechInfo(testInfo.brand, testInfo.model)
        //then
        verify(exactly = 1) { carDataSource.getTechInfo(testInfo.brand, testInfo.model) }
        assertEquals(info, testInfo)
    }

    @Test
    fun `get no tech from datasource - throw UnknownTechException`() {
        //given
        every { carDataSource.getTechInfo(any(), any()) }.returns(null)
        val testInfo = buildTechInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getTechInfo(testInfo.brand, testInfo.model) }
        //then
        assertThat(exceptionNoInfo is TechInfoException.UnknownCarException)
    }

    @Test
    fun `add tech to service`() {
        //given
        val testInfo = buildTechInfo()
        //when
        service.addTechInfo(testInfo)
        //then
        verify(exactly = 1) { carDataSource.addTechInfo(testInfo) }
    }
}
