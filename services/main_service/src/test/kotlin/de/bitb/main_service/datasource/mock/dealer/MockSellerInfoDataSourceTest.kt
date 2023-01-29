package de.bitb.main_service.datasource.mock.dealer

import de.bitb.main_service.builder.buildSaleInfo
import de.bitb.main_service.datasource.dealer.SaleInfoDataSourceMock
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test

internal class MockSellerInfoDataSourceTest {

    private val dataSource = SaleInfoDataSourceMock()

    @Test
    fun `get no sale info from data source`() {
        //given
        val key = "bullshit"
        //when
        val exception = dataSource.getSaleInfo(key)
        //then
        assertThat(exception == null)
    }

    @Test
    fun `get sale info by key from data source`() {
        //given
        val saveInfo = buildSaleInfo()
        dataSource.addSaleInfo(saveInfo)
        //when
        val info = dataSource.getSaleInfo(saveInfo.key)
        //then
        assertThat(info === saveInfo)
    }
}