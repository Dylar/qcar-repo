package de.bitb.main_service.exceptions

sealed class SellInfoException(msg: String) : Exception(msg) {
    class UnknownKeyException(msg: String) : SellInfoException(msg)
    class InvalidKeyException(msg: String) : SellInfoException(msg)
}