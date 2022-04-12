package de.bitb.testingApi.exceptions

sealed class ConfigException(msg: String) : Exception(msg) {
    class UnknownConfigTypeException(msg: String) : ConfigException(msg)
    class WrongConfigValueException(msg: String) : ConfigException(msg)
}