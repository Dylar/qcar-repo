package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.ConfigException
import de.bitb.main_service.models.SellInfo
import de.bitb.main_service.service.SellInfoService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(SELL_INFO_URL_V1)
class SellInfoController(private val service: SellInfoService) {

    @ExceptionHandler(ConfigException::class)
    fun handleConfigException(e: ConfigException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addSellInfo(@RequestBody info: SellInfo) = service.addSellInfo(info)

}