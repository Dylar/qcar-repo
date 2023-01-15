package de.bitb.main_service.service

import de.bitb.main_service.datasource.dealer.SELL_REPOSITORY_IN_USE
import de.bitb.main_service.datasource.dealer.SellInfoDataSource
import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.models.SellInfo
import de.bitb.main_service.exceptions.validateSellInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class SellInfoService(
    @Qualifier(SELL_REPOSITORY_IN_USE) @Autowired val sellDS: SellInfoDataSource
) {
    private val log: Logger = LoggerFactory.getLogger(SellInfoService::class.java)

    @Throws(SellInfoException::class)
    fun addSellInfo(info: SellInfo) {
        validateSellInfo(info)
        sellDS.addSellInfo(generateKey(info))
    }

    private fun generateKey(info: SellInfo): SellInfo =
//        info.copy(key = Base64.getEncoder().encodeToString(UUID.randomUUID().toString().toByteArray()))
        info.copy(key = "V2VubkR1RGFzRW50c2NobMO8c3NlbHN0TWF4aSxiaXN0ZVNjaG9uR3V0OlAK")

    @Throws(SellInfoException.UnknownKeyException::class)
    fun getSellInfo(key: String): SellInfo {
        return sellDS.getSellInfo(key)
            ?: throw SellInfoException.UnknownKeyException(key)
    }
}