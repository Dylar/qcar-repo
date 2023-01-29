package de.bitb.main_service.exceptions

import de.bitb.main_service.models.CarLink
import de.bitb.main_service.models.DealerInfo
import de.bitb.main_service.models.SaleInfo
import de.bitb.main_service.models.SellerInfo


@Throws(CarLinkException::class)
fun validateCarLink(info: CarLink) {
    if (info.dealer.isBlank()) {
        throw CarLinkException.EmptyDealerException()
    }
    if (info.brand.isBlank()) {
        throw CarLinkException.EmptyBrandException()
    }
    if (info.model.isBlank()) {
        throw CarLinkException.EmptyModelException()
    }
}

@Throws(SaleInfoException::class)
fun validateSaleInfo(info: SaleInfo) {
    if (info.brand.isBlank()) {
        throw SaleInfoException.EmptyBrandException()
    }
    if (info.model.isBlank()) {
        throw SaleInfoException.EmptyModelException()
    }
    if (info.seller.isBlank()) {
        throw SaleInfoException.EmptySellerException()
    }
    if (info.dealer.isBlank()) {
        throw SaleInfoException.EmptyDealerException()
    }
    if (info.key.isNotBlank()) {
        throw SaleInfoException.NotEmptyKeyException()
    }
    if (info.intro.isBlank()) {
        throw SaleInfoException.EmptyIntroException()
    }
    if (info.videos.isEmpty()) {
        throw SaleInfoException.NoVideosException()
    }
    info.videos.forEach {
        if (it.value.isEmpty()) {
            throw SaleInfoException.NoVideosForCategoryException(it.key)
        }
    }
}

@Throws(DealerInfoException::class)
fun validateDealerInfo(info: DealerInfo) {
    if (info.name.isBlank()) {
        throw DealerInfoException.EmptyNameException()
    }
    if (info.address.isBlank()) {
        throw DealerInfoException.EmptyAddressException()
    }
}

@Throws(SellerInfoException::class)
fun validateSellerInfo(info: SellerInfo) {
    if (info.dealer.isBlank()) {
        throw SellerInfoException.EmptyDealerException()
    }
    if (info.name.isBlank()) {
        throw SellerInfoException.EmptySellerException()
    }
}