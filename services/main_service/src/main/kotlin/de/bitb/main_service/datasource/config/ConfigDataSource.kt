package de.bitb.main_service.datasource.config

import de.bitb.main_service.models.ConfigData
import de.bitb.main_service.models.Configuration
import org.springframework.stereotype.Repository

interface ConfigDataSource {
    fun retrieveConfig() : Configuration

    fun setConfig(config: ConfigData): ConfigData
}

@Repository("database")
class DBConfigDataSource : ConfigDataSource {
    override fun retrieveConfig(): Configuration {
        TODO("Not yet implemented")
    }

    override fun setConfig(config: ConfigData): ConfigData {
        TODO("Not yet implemented")
    }
}