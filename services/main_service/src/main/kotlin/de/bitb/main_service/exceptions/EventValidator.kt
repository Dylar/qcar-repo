package de.bitb.main_service.exceptions

import de.bitb.main_service.models.*

@Throws(FeedbackException::class)
fun validateFeedback(feedback: Feedback) {
    if (feedback.date.isBlank()) {
        throw FeedbackException.EmptyDateException()
    }
    try{
        feedback.dateAsDateTime()
    }catch (e: Exception){
        throw FeedbackException.WrongDateFormatException(feedback.date)
    }
    if (feedback.text.isBlank()) {
        throw FeedbackException.EmptyTextException()
    }
}

@Throws(TrackingException::class)
fun validateTracking(feedback: Tracking) {
    if (feedback.date.isBlank()) {
        throw TrackingException.EmptyDateException()
    }
    try{
        feedback.dateAsDateTime()
    }catch (e: Exception){
        throw TrackingException.WrongDateFormatException(feedback.date)
    }
    if (feedback.text.isBlank()) {
        throw TrackingException.EmptyTextException()
    }
}