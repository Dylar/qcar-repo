package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.TechInfo
import de.bitb.main_service.service.CarInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(CAR_INFO_URL_V1)
class CarInfoController(private val service: CarInfoService) {

    private val log: Logger = LoggerFactory.getLogger(CarInfoController::class.java)

    @ExceptionHandler(CarInfoException::class)
    fun handleException(e: CarInfoException): ResponseEntity<String> {
        log.error(e.message)
        return ResponseEntity(e.message, HttpStatus.BAD_REQUEST)
    }

    @ExceptionHandler(CarInfoException.UnknownCarException::class)
    fun handleException(e: CarInfoException.UnknownCarException): ResponseEntity<String> {
        log.error(e.message)
        return ResponseEntity(e.message, HttpStatus.NOT_FOUND)
    }

    @ExceptionHandler(SellInfoException.UnknownKeyException::class)
    fun handleUnknownKeyException(e: SellInfoException.UnknownKeyException): ResponseEntity<String> {
        log.error(e.message)
        return ResponseEntity(e.message, HttpStatus.NOT_FOUND)
    }

    @GetMapping("/{key}")
    fun getSoldCarInfo(@PathVariable key: String): CarInfo = service.getSoldCarInfo(key)

    @GetMapping("/{brand}/{model}")
    fun getCarInfo(@PathVariable brand: String, @PathVariable model: String): CarInfo =
            service.getCarInfo(brand, model)

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addCarInfo(@RequestBody info: CarInfo) = service.addCarInfo(info)

}