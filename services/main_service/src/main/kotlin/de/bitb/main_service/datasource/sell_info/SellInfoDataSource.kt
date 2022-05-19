package de.bitb.main_service.datasource.sell_info

import de.bitb.main_service.models.SellInfo
import org.springframework.stereotype.Repository

interface SellInfoDataSource {
    fun getSellInfo(key: String): SellInfo?

    fun addSellInfo(info: SellInfo)
}

@Repository("sell_info_database")
class DBSellInfoDataSource : SellInfoDataSource {
    override fun getSellInfo(key: String): SellInfo? {
        TODO("Not yet implemented")
    }

    override fun addSellInfo(info: SellInfo) {
        TODO("Not yet implemented")
    }
}