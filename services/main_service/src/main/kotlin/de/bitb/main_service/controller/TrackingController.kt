package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.TrackingException
import de.bitb.main_service.models.Tracking
import de.bitb.main_service.service.TrackingService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(TRACKING_URL_V1)
class TrackingController @Autowired constructor(
    private val service: TrackingService
) {

    private val log: Logger = LoggerFactory.getLogger(TrackingController::class.java)

    @ExceptionHandler(TrackingException::class)
    fun handleException(e: TrackingException): ResponseEntity<String> {
        log.error(e.message)
        return ResponseEntity(e.message, HttpStatus.BAD_REQUEST)
    }

    @ExceptionHandler(TrackingException.NoTrackingException::class)
    fun handleException(e: TrackingException.NoTrackingException): ResponseEntity<String> {
        log.error(e.message)
        return ResponseEntity(e.message, HttpStatus.NOT_FOUND)
    }

    @GetMapping
    fun getTracking(): List<Tracking> {
        log.info("getTracking")
        return service.getTracking()
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addTracking(@RequestBody tracking: Tracking) {
        log.info("addTracking: $tracking")
        service.addTracking(tracking)
    }

}