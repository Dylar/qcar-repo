package de.bitb.main_service.datasource.mock

import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.datasource.car_info.MockCarInfoDataSource
import org.assertj.core.api.AssertionsForInterfaceTypes.assertThat
import org.junit.jupiter.api.Test


internal class MockCarInfoDataSourceTest {

    private val dataSource = MockCarInfoDataSource()

    @Test
    fun `get no car info from data source`() {
        //given
        val info = buildCarInfo()
        //when
        val exceptionBullshit = dataSource.getCarInfo("bullshit", "bullshit")
        val exceptionBrandBullshit = dataSource.getCarInfo("bullshit", info.model)
        val exceptionModelBullshit = dataSource.getCarInfo(info.brand, "bullshit")
        //then
        assertThat(exceptionBullshit == null)
        assertThat(exceptionBrandBullshit == null)
        assertThat(exceptionModelBullshit == null)
    }

    @Test
    fun `get car info by brand and model from data source`() {
        //given
        val saveInfo = buildCarInfo()
        dataSource.addCarInfo(saveInfo)
        //when
        val info = dataSource.getCarInfo(saveInfo.brand, saveInfo.model)
        //then
        assertThat(info === saveInfo)
    }

}