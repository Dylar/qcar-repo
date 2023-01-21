package de.bitb.main_service.exceptions

import de.bitb.main_service.models.CarLink
import de.bitb.main_service.models.DealerInfo
import de.bitb.main_service.models.SellInfo
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

@Throws(SellInfoException::class)
fun validateSellInfo(info: SellInfo) {
    if (info.brand.isBlank()) {
        throw SellInfoException.EmptyBrandException()
    }
    if (info.model.isBlank()) {
        throw SellInfoException.EmptyModelException()
    }
    if (info.seller.isBlank()) {
        throw SellInfoException.EmptySellerException()
    }
    if (info.dealer.isBlank()) {
        throw SellInfoException.EmptyDealerException()
    }
    if (info.key.isNotBlank()) {
        throw SellInfoException.NotEmptyKeyException()
    }
    if (info.intro.isBlank()) {
        throw SellInfoException.EmptyIntroException()
    }
    if (info.videos.isEmpty()) {
        throw SellInfoException.NoVideosException()
    }
    info.videos.forEach {
        if (it.value.isEmpty()) {
            throw SellInfoException.NoVideosForCategoryException(it.key)
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