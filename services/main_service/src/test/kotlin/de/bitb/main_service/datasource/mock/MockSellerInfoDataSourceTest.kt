package de.bitb.main_service.datasource.mock

import de.bitb.main_service.builder.buildSellInfo
import de.bitb.main_service.datasource.dealer.SellInfoDataSourceMock
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test

internal class MockSellerInfoDataSourceTest {

    private val dataSource = SellInfoDataSourceMock()

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