package de.bitb.main_service.datasource.sell_info

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(SELL_REPOSITORY_MOCK)
class MockSellInfoDataSource : SellInfoDataSource {

    private val log: Logger = LoggerFactory.getLogger(MockSellInfoDataSource::class.java)

    private val sellInfoDb = mutableMapOf<String, SellInfo>()

    override fun getSellInfo(key: String): SellInfo? {
        log.debug("getSellInfo")
        return sellInfoDb[key]
    }

    override fun addSellInfo(info: SellInfo) {
        log.debug("addSellInfo")
        sellInfoDb[info.key] = info
    }

}