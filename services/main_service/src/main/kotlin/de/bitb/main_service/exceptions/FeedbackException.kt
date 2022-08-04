package de.bitb.main_service.exceptions

import java.time.format.DateTimeFormatter

sealed class FeedbackException(msg: String) : Exception(msg) {
    class NoFeedbackException : FeedbackException("No feedback found")
    class EmptyDateException : FeedbackException("Date is empty")
    class WrongDateFormatException(date: String) :
        FeedbackException("Wrong date format. Was $date, but expecting ${DateTimeFormatter.ISO_OFFSET_DATE_TIME}")
    class EmptyTextException : FeedbackException("Text is empty")
}