package de.bitb.main_service.service

import de.bitb.main_service.datasource.sell_info.SellInfoDataSource
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.models.SellInfo
import de.bitb.main_service.models.validateSellInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class SellInfoService(
        @Qualifier("sell_info_database_mock") @Autowired val sellDS: SellInfoDataSource
) {
    private val log: Logger = LoggerFactory.getLogger(SellInfoService::class.java)

    @Throws(SellInfoException::class)
    fun addSellInfo(info: SellInfo) {
        log.info("addSellInfo")
        validateSellInfo(info)
        sellDS.addSellInfo(info)
    }
}