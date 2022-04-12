package de.bitb.main_service.exceptions

sealed class ConfigException(msg: String) : Exception(msg) {
    class UnknownConfigTypeException(msg: String) : ConfigException(msg)
    class WrongConfigValueException(msg: String) : ConfigException(msg)
}