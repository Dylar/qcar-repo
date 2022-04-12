package de.bitb.main_service.models

import com.fasterxml.jackson.annotation.JsonCreator


data class ConfigData(
    val type: ConfigType,
    val value: Any,
)

data class Configuration(val values: MutableMap<ConfigType, Any>) {
    fun getConfigData(type: ConfigType): ConfigData {
        val value = values[type] ?: throw NoSuchElementException("No Config ($type) found")
        return ConfigData(type, value)
    }
}

enum class ConfigType {
    UNKNOWN, COLOR;

    companion object {
        //@JvmStatic
        @JsonCreator
        fun getConfigType(name: String?): ConfigType? {
            if (name == null) return null
            for (i in values()) {
                if (i.toString() == name) return i
            }
            return null
        }
    }
}

enum class COLORS(val value: String) {
    TEAL_GREEN("#2cbcc1"),
    TEAL_BLUE("#1ea6d4"),
    PLAIN_RED("#FF0000"),
}