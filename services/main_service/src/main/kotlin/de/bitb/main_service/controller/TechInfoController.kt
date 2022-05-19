package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.TechInfoException
import de.bitb.main_service.models.TechInfo
import de.bitb.main_service.service.CarInfoService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(TECH_INFO_URL_V1)
class TechInfoController(private val service: CarInfoService) {

    @ExceptionHandler(TechInfoException::class)
    fun handleException(e: TechInfoException): ResponseEntity<String> =
            ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @ExceptionHandler(TechInfoException.UnknownCarException::class)
    fun handleException(e: TechInfoException.UnknownCarException): ResponseEntity<String> =
            ResponseEntity(e.message, HttpStatus.NOT_FOUND)

    @GetMapping("/{brand}/{model}")
    fun getTechInfo(@PathVariable brand: String, @PathVariable model: String): TechInfo =
            service.getTechInfo(brand, model)

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addTechInfo(@RequestBody info: TechInfo) = service.addTechInfo(info)

}