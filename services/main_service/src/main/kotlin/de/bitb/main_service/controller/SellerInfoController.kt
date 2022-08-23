package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.SellerInfoException
import de.bitb.main_service.models.SellerInfo
import de.bitb.main_service.service.SellerInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(SELLER_INFO_URL_V1)
class SellerInfoController(private val service: SellerInfoService) {

    private val log: Logger = LoggerFactory.getLogger(SellerInfoController::class.java)

    @ExceptionHandler(SellerInfoException::class)
    fun handleException(e: SellerInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @ExceptionHandler(SellerInfoException.UnknownSellerException::class)
    fun handleUnknownSellerException(e: SellerInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.NOT_FOUND)

    @GetMapping("/{dealer}/{name}")
    fun getSellerInfo(@PathVariable dealer: String, @PathVariable name: String): SellerInfo {
        log.info("getSellerInfo: $dealer - $name")
        return service.getSellerInfo(dealer, name)
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addSellerInfo(@RequestBody info: SellerInfo) {
        log.info("addSellerInfo: $info")
        service.addSellerInfo(info)
    }
}