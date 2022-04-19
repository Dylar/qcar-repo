package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.ConfigException
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.ConfigData
import de.bitb.main_service.models.SellInfo
import de.bitb.main_service.service.CarInfoService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("api/v1/carinfo")
class CarInfoController(private val service: CarInfoService) {

    @ExceptionHandler(ConfigException::class)
    fun handleConfigException(e: ConfigException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @GetMapping("/{key}")
    fun getCarInfo(@PathVariable key: String): CarInfo = service.getCarInfo(key)

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addCarInfo(@RequestBody info: CarInfo) = service.addCarInfo(info)

}