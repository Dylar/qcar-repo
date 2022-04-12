package de.bitb.main_service.service

import de.bitb.main_service.datasource.config.ConfigDataSource
import de.bitb.main_service.exceptions.ConfigException
import de.bitb.main_service.models.COLORS
import de.bitb.main_service.models.ConfigData
import de.bitb.main_service.models.ConfigType
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class ConfigService(@Qualifier("mock") @Autowired val dataSource: ConfigDataSource) {
    fun getConfig(type: ConfigType): ConfigData = dataSource.retrieveConfig().getConfigData(type)

    fun setConfig(config: ConfigData): ConfigData {
        validateConfig(config);
        return dataSource.setConfig(config)
    }

    private fun validateConfig(config: ConfigData) {
        when (config.type) {
            ConfigType.COLOR -> {
                COLORS.values().firstOrNull { it.value == config.value || it.name == config.value }
                    ?: throw ConfigException.WrongConfigValueException("${config.value} is not a valid color")
            }
            else -> throw ConfigException.UnknownConfigTypeException("${config.type} is not a valid config type")
        }
    }
}