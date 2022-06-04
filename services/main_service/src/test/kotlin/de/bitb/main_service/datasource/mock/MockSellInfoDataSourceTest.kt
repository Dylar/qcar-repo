package de.bitb.main_service.datasource.mock

import de.bitb.main_service.builder.buildSellInfo
import de.bitb.main_service.datasource.sell_info.MockSellInfoDataSource
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test

internal class MockSellInfoDataSourceTest {

    private val dataSource = MockSellInfoDataSource()

    @Test
    fun `get no sell info from data source`() {
        //given
        val key = "bullshit"
        //when
        val exception = dataSource.getSellInfo(key)
        //then
        assertThat(exception == null)
    }

    @Test
    fun `get sell info by key from data source`() {
        //given
        val saveInfo = buildSellInfo()
        dataSource.addSellInfo(saveInfo)
        //when
        val sellInfo = dataSource.getSellInfo(saveInfo.key)
        //then
        assertThat(sellInfo === saveInfo)
    }
}