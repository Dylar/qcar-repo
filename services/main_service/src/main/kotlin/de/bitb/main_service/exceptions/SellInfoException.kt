package de.bitb.main_service.exceptions

sealed class SellerInfoException(msg: String) : Exception(msg) {
    class UnknownSellerException(dealer: String, name: String) :
        SellerInfoException("Unknown seller ($name) for dealer ($dealer")
    class EmptyCarDealerException : SellerInfoException("Car dealer is empty")
    class EmptySellerException : SellerInfoException("Seller is empty")
}

sealed class SellInfoException(msg: String) : Exception(msg) {
    class UnknownKeyException(msg: String) : SellInfoException(msg)
    class InvalidKeyException(msg: String) : SellInfoException(msg)
    class EmptyBrandException : SellInfoException("Brand is empty")
    class EmptyModelException : SellInfoException("Model is empty")
    class EmptySellerException : SellInfoException("Seller is empty")
    class EmptyCarDealerException : SellInfoException("Car dealer is empty")
    class NotEmptyKeyException : SellInfoException("Key is NOT empty")
    class NoVideosException : SellInfoException("No videos")
}