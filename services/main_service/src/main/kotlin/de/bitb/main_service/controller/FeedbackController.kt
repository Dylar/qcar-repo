package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.FeedbackException
import de.bitb.main_service.models.Feedback
import de.bitb.main_service.service.FeedbackService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(FEEDBACK_URL_V1)
class FeedbackController @Autowired constructor(
    private val service: FeedbackService
) {

    private val log: Logger = LoggerFactory.getLogger(FeedbackController::class.java)

    @ExceptionHandler(FeedbackException::class)
    fun handleException(e: FeedbackException): ResponseEntity<String> {
        log.error(e.message)
        return ResponseEntity(e.message, HttpStatus.BAD_REQUEST)
    }

    @ExceptionHandler(FeedbackException.NoFeedbackException::class)
    fun handleException(e: FeedbackException.NoFeedbackException): ResponseEntity<String> {
        log.error(e.message)
        return ResponseEntity(e.message, HttpStatus.NOT_FOUND)
    }

    @GetMapping
    fun getFeedback(): List<Feedback> {
        log.info("getFeedback")
        return service.getFeedback()
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addFeedback(@RequestBody feedback: Feedback) {
        log.info("addFeedback: $feedback")
        service.addFeedback(feedback)
    }

}