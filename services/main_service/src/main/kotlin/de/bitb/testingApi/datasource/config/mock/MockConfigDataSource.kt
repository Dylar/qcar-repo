package de.bitb.testingApi.datasource.config.mock

import de.bitb.testingApi.datasource.config.ConfigDataSource
import de.bitb.testingApi.models.COLORS
import de.bitb.testingApi.models.ConfigData
import de.bitb.testingApi.models.ConfigType
import de.bitb.testingApi.models.Configuration
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