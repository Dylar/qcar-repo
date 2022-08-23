package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.SellInfo
import de.bitb.main_service.service.SellInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(SELL_INFO_URL_V1)
class SellInfoController(private val service: SellInfoService) {

    private val log: Logger = LoggerFactory.getLogger(SellInfoController::class.java)

    @ExceptionHandler(SellInfoException::class)
    fun handleException(e: SellInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @ExceptionHandler(SellInfoException.UnknownKeyException::class)
    fun handleUnknownKeyException(e: SellInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.NOT_FOUND)

    @GetMapping("/{key}")
    fun getSellInfo(@PathVariable key: String): SellInfo {
        log.info("getSellInfo: $key")
        return service.getSellInfo(key)
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addSellInfo(@RequestBody info: SellInfo) {
        log.info("addSellInfo: $info")
        service.addSellInfo(info)
    }

}