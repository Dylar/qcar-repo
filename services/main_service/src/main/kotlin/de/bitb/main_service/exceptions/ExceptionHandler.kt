package de.bitb.main_service.exceptions

import com.fasterxml.jackson.core.JsonParseException
import com.fasterxml.jackson.databind.JsonMappingException
import com.fasterxml.jackson.databind.exc.MismatchedInputException
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.http.converter.HttpMessageNotReadableException
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler


@ControllerAdvice
class ExceptionHandler {

    private val log: Logger = LoggerFactory.getLogger(ExceptionHandler::class.java)

    @ExceptionHandler(NoSuchElementException::class)
    fun handleNotFound(e: NoSuchElementException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.NOT_FOUND)

    @ExceptionHandler(Exception::class)
    fun handleAnything(e: Exception): ResponseEntity<String> {
        log.error("Unhandled exception:\n${e.message}")
        return ResponseEntity(e.message, HttpStatus.BAD_REQUEST)
    }

    /**
     * Common handling of JSON parsing/mapping exceptions. Care is used to not return error
     * details that would reveal internal Java package/class names.
     */
    @ExceptionHandler(HttpMessageNotReadableException::class)
    fun processConversionException(e: HttpMessageNotReadableException): ResponseEntity<String>? {
        val msg = when (val cause = e.cause) {
            is JsonParseException -> cause.originalMessage
            is MismatchedInputException ->
                if (cause.path != null && cause.path.size > 0)
                    "Invalid request field: " + cause.path[0].fieldName
                else "Invalid request message"
            is JsonMappingException ->
                if (cause.path != null && cause.path.size > 0)
                    "Invalid request field: " + cause.path[0].fieldName + ": " + cause.originalMessage
                else cause.originalMessage
            else -> return handleAnything(e)
        }
        return ResponseEntity("Incorrect JSON format:\n${msg}", HttpStatus.BAD_REQUEST)
    }

}