package de.bitb.main_service.datasource.sell_info

import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository("sell_info_database_mock")
class MockSellInfoDataSource : SellInfoDataSource {

    private val sellInfoDb = mutableMapOf<String, SellInfo>()

    override fun getSellInfo(key: String): SellInfo =
            sellInfoDb[key] ?: throw SellInfoException.UnknownKeyException(key)

    override fun addSellInfo(info: SellInfo) {
        sellInfoDb[info.key] = info
    }

}