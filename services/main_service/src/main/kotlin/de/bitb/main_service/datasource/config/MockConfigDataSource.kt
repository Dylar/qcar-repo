package de.bitb.main_service.datasource.config

import de.bitb.main_service.models.COLORS
import de.bitb.main_service.models.ConfigData
import de.bitb.main_service.models.ConfigType
import de.bitb.main_service.models.Configuration
import org.springframework.stereotype.Repository

@Repository("mock")
class MockConfigDataSource : ConfigDataSource {

    private val configuration = Configuration(
        mutableMapOf(
            ConfigType.COLOR to COLORS.TEAL_GREEN
        )
    )

    override fun retrieveConfig(): Configuration = configuration

    override fun setConfig(config: ConfigData): ConfigData {
        configuration.values[config.type] = config.value
        return configuration.getConfigData(config.type)
    }
}