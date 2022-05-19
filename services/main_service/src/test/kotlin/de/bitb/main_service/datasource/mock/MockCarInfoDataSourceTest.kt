package de.bitb.main_service.datasource.mock

import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.datasource.car_info.MockCarInfoDataSource
import de.bitb.main_service.exceptions.CarInfoException
import org.assertj.core.api.AssertionsForInterfaceTypes.assertThat
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception


internal class MockCarInfoDataSourceTest {

    private val dataSource = MockCarInfoDataSource()

    @Test
    fun `get no car info from data source - throw UnknownCarException`() {
        //given
        val carInfo = buildCarInfo()
        //when
        val exceptionBullshit: Exception = assertThrows { dataSource.getCarInfo("bullshit", "bullshit") }
        val exceptionBrandBullshit: Exception = assertThrows { dataSource.getCarInfo("bullshit", carInfo.model) }
        val exceptionModelBullshit: Exception = assertThrows { dataSource.getCarInfo(carInfo.brand, "bullshit") }
        //then
        assertThat(exceptionBullshit is CarInfoException.UnknownCarException)
        assertThat(exceptionBrandBullshit is CarInfoException.UnknownCarException)
        assertThat(exceptionModelBullshit is CarInfoException.UnknownCarException)
    }

    @Test
    fun `get car info by brand and model from data source`() {
        //given
        val saveInfo = buildCarInfo()
        dataSource.addCarInfo(saveInfo)
        //when
        val carInfo = dataSource.getCarInfo(saveInfo.brand, saveInfo.model)
        //then
        assertThat(carInfo === saveInfo)
    }
}