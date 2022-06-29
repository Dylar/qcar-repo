package de.bitb.main_service.datasource.seller_info

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(SELLER_REPOSITORY_MOCK)
class MockSellerInfoDataSource : SellerInfoDataSource {

    private val log: Logger = LoggerFactory.getLogger(MockSellerInfoDataSource::class.java)

    private val sellerInfoDb = mutableMapOf<String, SellerInfo>()

    override fun getSellerInfo(dealer: String, name:String): SellerInfo? {
        log.debug("getSellerInfo")
        return sellerInfoDb[name]
    }

    override fun addSellerInfo(info: SellerInfo) {
        log.debug("addSellerInfo")
        sellerInfoDb[info.name] = info
    }

}