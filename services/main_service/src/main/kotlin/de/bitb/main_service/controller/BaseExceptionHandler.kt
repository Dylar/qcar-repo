package de.bitb.main_service.controller

import org.slf4j.Logger
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity

abstract class BaseExceptionHandler {
    abstract val log: Logger

    protected fun badRequest(msg: String): ResponseEntity<String> {
        log.error(msg)
        return ResponseEntity(msg, HttpStatus.BAD_REQUEST)
    }

    protected fun notFound(msg: String): ResponseEntity<String> {
        log.error(msg)
        return ResponseEntity(msg, HttpStatus.NOT_FOUND)
    }
}