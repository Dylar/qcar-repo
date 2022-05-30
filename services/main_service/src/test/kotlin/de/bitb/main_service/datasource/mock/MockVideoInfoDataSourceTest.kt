package de.bitb.main_service.datasource.mock

import de.bitb.main_service.builder.buildVideoInfo
import de.bitb.main_service.datasource.video_info.MockVideoInfoDataSource
import org.assertj.core.api.AssertionsForInterfaceTypes.assertThat
import org.junit.jupiter.api.Test

internal class MockVideoInfoDataSourceTest {

    private val dataSource = MockVideoInfoDataSource()

    @Test
    fun `get no video info from data source`() {
        //when
        val exceptionBullshit = dataSource.getVideoInfo("bullshit", "bullshit", "bullshit")
        //then
        assertThat(exceptionBullshit == null)
    }

    @Test
    fun `get video info by brand and model from data source`() {
        //given
        val saveInfo = buildVideoInfo()
        dataSource.addVideoInfo(saveInfo)
        //when
        val info = dataSource.getVideoInfo(saveInfo.brand, saveInfo.model, saveInfo.name)
        //then
        assertThat(info === saveInfo)
    }
}