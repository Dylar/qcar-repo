package de.bitb.main_service.service

import de.bitb.main_service.builder.buildSellInfo
import de.bitb.main_service.datasource.sell_info.SellInfoDataSource
import io.mockk.mockk
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

internal class SellServiceTest {

    private lateinit var dataSource: SellInfoDataSource
    private lateinit var service: SellInfoService

    @BeforeEach
    fun setUp(){
        dataSource = mockk(relaxed = true)
        service = SellInfoService(dataSource)
    }

    @Test
    fun `add sell to service`() {
        //given
        val testInfo = buildSellInfo()
        //when
        service.addSellInfo(testInfo)
        //then
        verify(exactly = 1) { dataSource.addSellInfo(testInfo) }
    }

}