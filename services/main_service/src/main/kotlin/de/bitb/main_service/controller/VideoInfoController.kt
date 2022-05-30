package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.VideoInfoException
import de.bitb.main_service.models.VideoInfo
import de.bitb.main_service.service.VideoInfoService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(VIDEO_INFO_URL_V1)
class VideoInfoController(private val service: VideoInfoService) {

    @ExceptionHandler(VideoInfoException::class)
    fun handleException(e: VideoInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @ExceptionHandler(VideoInfoException.UnknownVideoException::class)
    fun handleException(e: VideoInfoException.UnknownVideoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.NOT_FOUND)

    @GetMapping("/{brand}/{model}/{name}")
    fun getVideoInfo(
        @PathVariable brand: String,
        @PathVariable model: String,
        @PathVariable name: String
    ): VideoInfo =
        service.getVideoInfo(brand, model, name)

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addVideoInfo(@RequestBody info: VideoInfo) = service.addVideoInfo(info)

}