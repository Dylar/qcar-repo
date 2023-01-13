package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.CarLink
import de.bitb.main_service.service.CarInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(CAR_INFO_URL_V1)
class CarInfoController @Autowired constructor(
    private val service: CarInfoService
) {

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

    @GetMapping("/{brand}/{model}")
    fun getCarInfo(@PathVariable brand: String, @PathVariable model: String): CarInfo {
        log.info("getCarInfo: $brand - $model")
        return service.getCarInfo(brand, model)
    }

    @GetMapping("/all/{dealer}")
    fun getCarInfos(@PathVariable dealer: String): List<CarInfo> {
        log.info("getCarInfos") //TODO test me
        return service.getCarInfos(dealer)
    }

    @PostMapping("/addCar")
    @ResponseStatus(HttpStatus.CREATED)
    fun addCarInfo(@RequestBody info: CarInfo) {
        log.info("addCarInfo: $info")
        service.addCarInfo(info)
    }

    @PostMapping("/linkCar")
    @ResponseStatus(HttpStatus.CREATED)
    fun linkCarToDealer(@RequestBody info: CarLink) {
        log.info("linkCarToDealer") //TODO test me
        service.linkCarToDealer(info)
    }
}