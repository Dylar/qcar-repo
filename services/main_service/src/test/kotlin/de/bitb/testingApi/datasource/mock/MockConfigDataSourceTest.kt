package de.bitb.testingApi.datasource.mock

import allSatisfyKt
import de.bitb.testingApi.datasource.config.mock.MockConfigDataSource
import de.bitb.testingApi.models.ConfigType
import de.bitb.testingApi.models.Configuration
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test

internal class MockConfigDataSourceTest {

    private val configDataSource = MockConfigDataSource()

    @Test
    fun `test get config from data source`() {
        //when
        val config = configDataSource.retrieveConfig()
        //then
        assertThat(config.values).isNotEmpty
    }

    @Test
    fun `has color config`() {
        //when
        val config = configDataSource.retrieveConfig()
        //then
        assertThat(config).allSatisfyKt {
            assertThat(it.values.contains(ConfigType.COLOR))
        }
    }
}