package de.bitb.main_service.datasource.dealer

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(SELLER_REPOSITORY_MOCK)
class SellerInfoDataSourceMock : SellerInfoDataSource {

    private val log: Logger = LoggerFactory.getLogger(SellerInfoDataSourceMock::class.java)

    private val sellerInfoDb = mutableMapOf<String, SellerInfo>()

    override fun getSellerInfo(dealer: String, name:String): SellerInfo? {
        return sellerInfoDb[name]
    }

    override fun addSellerInfo(info: SellerInfo) {
        sellerInfoDb[info.name] = info
    }

}