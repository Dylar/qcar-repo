package de.bitb.main_service.datasource.mock

import de.bitb.main_service.builder.buildCategoryInfo
import de.bitb.main_service.datasource.category_info.MockCategoryInfoDataSource
import org.assertj.core.api.AssertionsForInterfaceTypes.assertThat
import org.junit.jupiter.api.Test

internal class MockCategoryInfoDataSourceTest {

    private val dataSource = MockCategoryInfoDataSource()

    @Test
    fun `get no category info from data source`() {
        //when
        val exceptionBullshit = dataSource.getCategoryInfo("bullshit")
        //then
        assertThat(exceptionBullshit == null)
    }

    @Test
    fun `get category info by brand and model from data source`() {
        //given
        val saveInfo = buildCategoryInfo()
        dataSource.addCategoryInfo(saveInfo)
        //when
        val info = dataSource.getCategoryInfo(saveInfo.name)
        //then
        assertThat(info === saveInfo)
    }
}