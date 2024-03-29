package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.VideoInfoException
import de.bitb.main_service.models.VideoInfo
import de.bitb.main_service.service.VideoInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(VIDEO_INFO_URL_V1)
class VideoInfoController(private val service: VideoInfoService) {

    private val log: Logger = LoggerFactory.getLogger(VideoInfoController::class.java)

    @ExceptionHandler(VideoInfoException::class)
    fun handleException(e: VideoInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @ExceptionHandler(VideoInfoException.UnknownVideoException::class)
    fun handleException(e: VideoInfoException.UnknownVideoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.NOT_FOUND)

    @GetMapping("/{brand}/{model}/{category}/{name}")
    fun getVideoInfo(
        @PathVariable brand: String,
        @PathVariable model: String,
        @PathVariable category: String,
        @PathVariable name: String
    ): VideoInfo {
        log.info("addVideoInfo: $brand - $model - $category - $name")
        return service.getVideoInfo(brand, model, category, name)
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addVideoInfo(@RequestBody info: VideoInfo) {
        log.info("addVideoInfo: $info")
        service.addVideoInfo(info)
    }

}