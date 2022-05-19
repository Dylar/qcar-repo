package de.bitb.main_service.exceptions

sealed class SellInfoException(msg: String) : Exception(msg) {
    class UnknownKeyException(msg: String) : SellInfoException(msg)
    class InvalidKeyException(msg: String) : SellInfoException(msg)
    class EmptyBrandException : SellInfoException("Brand is empty")
    class EmptyModelException : SellInfoException("Model is empty")
    class EmptySellerException : SellInfoException("Seller is empty")
    class EmptyCarDealerException : SellInfoException("Car dealer is empty")
    class EmptyKeyException : SellInfoException("Key is empty")
}