package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.CategoryInfoException
import de.bitb.main_service.exceptions.VideoInfoException
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler


@ControllerAdvice(basePackageClasses = [CarController::class])
class CarExceptionHandler : BaseExceptionHandler() {
    override val log: Logger = LoggerFactory.getLogger(CarExceptionHandler::class.java)

    // CAR
    @ExceptionHandler(CarInfoException::class)
    fun handleException(e: CarInfoException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(CarInfoException.UnknownCarException::class)
    fun handleException(e: CarInfoException.UnknownCarException): ResponseEntity<String> =
        notFound(e.message!!)

    // CATEGORY
    @ExceptionHandler(CategoryInfoException::class)
    fun handleException(e: CategoryInfoException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(CategoryInfoException.UnknownCategoryException::class)
    fun handleException(e: CategoryInfoException.UnknownCategoryException): ResponseEntity<String> =
        notFound(e.message!!)

    // VIDEO
    @ExceptionHandler(VideoInfoException::class)
    fun handleException(e: VideoInfoException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(VideoInfoException.UnknownVideoException::class)
    fun handleException(e: VideoInfoException.UnknownVideoException): ResponseEntity<String> =
        notFound(e.message!!)
}