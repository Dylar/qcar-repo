package de.bitb.main_service.exceptions

sealed class JSONValidationException(msg: String) : Exception("JSON invalid: $msg") {
    class CarInfoValidationException(msg: String) : JSONValidationException(msg)
    class SellInfoValidationException(msg: String) : JSONValidationException(msg)
}