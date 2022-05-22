package de.bitb.main_service.service

import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.builder.buildTechInfo
import de.bitb.main_service.datasource.car_info.CarInfoDataSource
import de.bitb.main_service.datasource.sell_info.SellInfoDataSource
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.TechInfoException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.hamcrest.MatcherAssert.assertThat
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class CarServiceTest {

    private lateinit var carDataSource: CarInfoDataSource
    private lateinit var sellDataSource: SellInfoDataSource
    private lateinit var service: CarInfoService

    @BeforeEach
    fun setUp(){
        carDataSource = mockk(relaxed = true)
        sellDataSource = mockk(relaxed = true)
        every { carDataSource.getCarInfo(any(),any()) }.returns(null)
        every { carDataSource.getTechInfo(any(),any()) }.returns(null)
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
        assertThat("Car info not equal", info == testInfo)
    }

    @Test
    fun `get no car from datasource - throw UnknownCarException`() {
        //given
        val testInfo = buildCarInfo()
        //when
        val exceptionNoInfo: Exception = assertThrows { service.getCarInfo(testInfo.brand, testInfo.model) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is CarInfoException.UnknownCarException)
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
    fun `get tech from service`() {
        //given
        val testInfo = buildTechInfo()
        every { carDataSource.getTechInfo(testInfo.brand, testInfo.model) }.returns(testInfo)
        //when
        val info = service.getTechInfo(testInfo.brand, testInfo.model)
        //then
        verify(exactly = 1) { carDataSource.getTechInfo(testInfo.brand, testInfo.model) }
        assertThat("Tech info not equal", info == testInfo)
    }

    @Test
    fun `get no tech from datasource - throw UnknownTechException`() {
        //given
        val testInfo = buildTechInfo()
        //when
        val exceptionNoInfo: Exception = assertThrows { service.getTechInfo(testInfo.brand, testInfo.model) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is TechInfoException.UnknownCarException)
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