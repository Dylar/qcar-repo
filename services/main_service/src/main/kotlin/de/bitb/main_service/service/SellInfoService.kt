package de.bitb.main_service.service

import de.bitb.main_service.datasource.sell_info.SellInfoDataSource
import de.bitb.main_service.models.SellInfo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class SellInfoService(
        @Qualifier("sell_info_database_mock") @Autowired val sellDS: SellInfoDataSource
) {

    fun addSellInfo(info: SellInfo) {
        sellDS.addSellInfo(info)
    }
}