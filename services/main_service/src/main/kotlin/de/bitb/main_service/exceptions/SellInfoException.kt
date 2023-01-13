package de.bitb.main_service.exceptions

sealed class DealerInfoException(msg: String) : Exception(msg) {
    class UnknownDealerException(name: String) :
        DealerInfoException("Unknown dealer ($name)")

    class EmptyNameException : DealerInfoException("Dealer name is empty")
    class EmptyAddressException : DealerInfoException("Address is empty")
}

sealed class SellerInfoException(msg: String) : Exception(msg) {
    class UnknownSellerException(dealer: String, name: String) :
        SellerInfoException("Unknown seller ($name) for dealer ($dealer)")

    class EmptyDealerException : SellerInfoException("Dealer is empty")
    class EmptySellerException : SellerInfoException("Seller is empty")
}

sealed class SellInfoException(msg: String) : Exception(msg) {
    class UnknownKeyException(msg: String) : SellInfoException(msg)
    class InvalidKeyException(msg: String) : SellInfoException(msg)
    class EmptyBrandException : SellInfoException("Brand is empty")
    class EmptyModelException : SellInfoException("Model is empty")
    class EmptySellerException : SellInfoException("Seller is empty")
    class EmptyDealerException : SellInfoException("Dealer is empty")
    class NotEmptyKeyException : SellInfoException("Key is NOT empty")
    class EmptyIntroException : SellInfoException("Intro path empty")
    class NoVideosException : SellInfoException("No videos")
    class NoVideosForCategoryException(category: String) : SellInfoException("No videos for category $category")
}