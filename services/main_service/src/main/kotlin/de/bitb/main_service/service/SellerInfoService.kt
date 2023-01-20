package de.bitb.main_service.service

import de.bitb.main_service.datasource.car.CAR_REPOSITORY_IN_USE
import de.bitb.main_service.datasource.car.CarInfoDataSource
import de.bitb.main_service.datasource.dealer.*
import de.bitb.main_service.exceptions.*
import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class SellerInfoService(
    @Qualifier(DEALER_REPOSITORY_IN_USE) @Autowired val dealerDS: DealerInfoDataSource,
    @Qualifier(SELLER_REPOSITORY_IN_USE) @Autowired val sellerDS: SellerInfoDataSource,
    @Qualifier(CAR_REPOSITORY_IN_USE) @Autowired val carDS: CarInfoDataSource,
    @Qualifier(CAR_LINK_REPOSITORY_IN_USE) @Autowired val carLinkDS: CarLinkDataSource,
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

    @Throws(DealerInfoException::class)
    fun addDealerInfo(info: DealerInfo) {
        validateDealerInfo(info)
        dealerDS.addDealerInfo(info)
    }

    @Throws(DealerInfoException.UnknownDealerException::class)
    fun getDealerInfo(name: String): DealerInfo {
        return dealerDS.getDealerInfo(name)
            ?: throw DealerInfoException.UnknownDealerException(name)
    }

    fun linkCarToDealer(info: CarLink) {
        validateCarLink(info)
        carLinkDS.addLink(info)
    }

    fun getCarInfos(dealer: String): List<CarInfo> {
        val links = carLinkDS.getLinks(dealer)
        return links?.mapNotNull { carDS.getCarInfo(it.brand, it.model) }
            ?: throw CarLinkException.NoCarLinkException(dealer)
    }

}