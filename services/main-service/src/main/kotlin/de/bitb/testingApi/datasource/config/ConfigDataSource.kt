package de.bitb.testingApi.datasource.config

import de.bitb.testingApi.models.ConfigData
import de.bitb.testingApi.models.Configuration
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