package de.bitb.testingApi.service

import de.bitb.testingApi.datasource.config.ConfigDataSource
import de.bitb.testingApi.models.ConfigType
import io.mockk.mockk
import io.mockk.verify
import org.junit.jupiter.api.Test

internal class ConfigServiceTest {

    private val dataSource: ConfigDataSource = mockk(relaxed = true);
    private val configService: ConfigService = ConfigService(dataSource)

    @Test
    fun `get config from service`() {
        //when
        configService.getConfig(ConfigType.COLOR);
        //then
        verify(exactly = 1) { dataSource.retrieveConfig() }
//        assertThat(config).isNotNull

    }
}