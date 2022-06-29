package de.bitb.main_service.service

import de.bitb.main_service.datasource.seller_info.SELLER_REPOSITORY_IN_USE
import de.bitb.main_service.datasource.seller_info.SellerInfoDataSource
import de.bitb.main_service.exceptions.SellerInfoException
import de.bitb.main_service.models.SellerInfo
import de.bitb.main_service.models.validateSellerInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class SellerInfoService(
    @Qualifier(SELLER_REPOSITORY_IN_USE) @Autowired val sellerDS: SellerInfoDataSource
) {
    private val log: Logger = LoggerFactory.getLogger(SellerInfoService::class.java)

    @Throws(SellerInfoException::class)
    fun addSellerInfo(info: SellerInfo) {
        validateSellerInfo(info)
        sellerDS.addSellerInfo(info)
    }

    @Throws(SellerInfoException.UnknownSellerException::class)
    fun getSellerInfo(dealer: String, name: String): SellerInfo {
        return sellerDS.getSellerInfo(dealer, name)
            ?: throw SellerInfoException.UnknownSellerException(dealer, name)
    }
}