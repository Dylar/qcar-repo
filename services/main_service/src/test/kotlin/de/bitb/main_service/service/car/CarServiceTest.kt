package de.bitb.main_service.service.car

import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.builder.buildEmptyCarInfo
import de.bitb.main_service.datasource.car.CarInfoDataSource
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.service.CarInfoService
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
    private lateinit var dataSource: CarInfoDataSource

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        service = CarInfoService(dataSource, mockk(relaxed = true), mockk(relaxed = true))
    }

    @Test
    fun `get car from service`() {
        //given
        val testInfo = buildCarInfo()
        every { dataSource.getCarInfo(testInfo.brand, testInfo.model) }.returns(testInfo)
        //when
        val info = service.getCarInfo(testInfo.brand, testInfo.model)
        //then
        verify(exactly = 1) { dataSource.getCarInfo(testInfo.brand, testInfo.model) }
        assertEquals(info, testInfo)
    }

    @Test
    fun `get no car from datasource - throw UnknownCarException`() {
        //given
        every { dataSource.getCarInfo(any(), any()) }.returns(null)
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
        verify(exactly = 1) { dataSource.addCarInfo(testInfo) }
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
        verify(exactly = 1) { dataSource.addCarInfo(emptyInfo) }
    }
}