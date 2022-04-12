package de.bitb.testingApi.controller

import de.bitb.testingApi.exceptions.ConfigException
import de.bitb.testingApi.models.ConfigData
import de.bitb.testingApi.models.ConfigType
import de.bitb.testingApi.service.ConfigService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("api/v1/config")
class ConfigController(private val service: ConfigService) {

    @ExceptionHandler(ConfigException::class)
    fun handleConfigException(e: ConfigException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @GetMapping("/{name}")
    fun getConfig(@PathVariable name: String): ConfigData {
        val type = ConfigType.valueOf(name)
        return service.getConfig(type)
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun setConfig(@RequestBody config: ConfigData) = service.setConfig(config)
}