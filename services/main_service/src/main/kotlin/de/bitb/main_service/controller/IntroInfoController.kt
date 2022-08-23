package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.IntroInfoException
import de.bitb.main_service.models.IntroInfo
import de.bitb.main_service.service.IntroInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(INTRO_INFO_URL_V1)
class IntroInfoController(private val service: IntroInfoService) {

    private val log: Logger = LoggerFactory.getLogger(IntroInfoController::class.java)

    @ExceptionHandler(IntroInfoException::class)
    fun handleException(e: IntroInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @ExceptionHandler(IntroInfoException.UnknownIntroException::class)
    fun handleUnknownIntroException(e: IntroInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.NOT_FOUND)

    @GetMapping("/{dealer}/{seller}/{brand}/{model}")
    fun getIntroInfo(
        @PathVariable dealer: String,
        @PathVariable seller: String,
        @PathVariable brand: String,
        @PathVariable model: String
    ): IntroInfo {
        log.info("getIntroInfo: $dealer - $seller - $brand - $model")
        return service.getIntroInfo(dealer, seller, brand, model)
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addIntroInfo(@RequestBody info: IntroInfo) {
        log.info("addIntroInfo: $info")
        service.addIntroInfo(info)
    }
}