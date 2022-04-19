package de.bitb.main_service.exceptions

sealed class CarInfoException(msg: String) : Exception(msg) {
    class UnknownCarException(brand: String, model: String) : CarInfoException("Brand: $brand, Model: $model")
}