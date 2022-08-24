package de.bitb.main_service.exceptions

sealed class FeedbackException(msg: String) : Exception(msg) {
    class NoFeedbackException : FeedbackException("No feedback found")
    class EmptyDateException : FeedbackException("Date is empty")
    class WrongDateFormatException(date: String) :
        FeedbackException("Wrong date format. Was $date, but expecting yyyy-MM-dd'T'HH:mm:ss.SSS")
    class EmptyTextException : FeedbackException("Text is empty")
}