package de.bitb.main_service.exceptions

sealed class SellerInfoException(msg: String) : Exception(msg) {
    class UnknownSellerException(dealer: String, name: String) :
        SellerInfoException("Unknown seller ($name) for dealer ($dealer")

    class EmptyDealerException : SellerInfoException("Dealer is empty")
    class EmptySellerException : SellerInfoException("Seller is empty")
}

sealed class IntroInfoException(msg: String) : Exception(msg) {
    class UnknownIntroException(dealer: String,seller: String, brand: String, model: String) :
        IntroInfoException("Unknown intro from $dealer $seller for $brand $model")

    class EmptyDealerException : IntroInfoException("Dealer is empty")
    class EmptySellerException : IntroInfoException("Seller is empty")
}

sealed class SellInfoException(msg: String) : Exception(msg) {
    class UnknownKeyException(msg: String) : SellInfoException(msg)
    class InvalidKeyException(msg: String) : SellInfoException(msg)
    class EmptyBrandException : SellInfoException("Brand is empty")
    class EmptyModelException : SellInfoException("Model is empty")
    class EmptySellerException : SellInfoException("Seller is empty")
    class EmptyDealerException : SellInfoException("Dealer is empty")
    class NotEmptyKeyException : SellInfoException("Key is NOT empty")
    class NoVideosException : SellInfoException("No videos")
    class NoVideosForCategoryException(category: String) : SellInfoException("No videos for category $category")
}