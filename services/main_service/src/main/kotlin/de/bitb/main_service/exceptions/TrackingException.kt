package de.bitb.main_service.exceptions

sealed class TrackingException(msg: String) : Exception(msg) {
    class NoTrackingException : TrackingException("No tracking found")
    class EmptyDateException : TrackingException("Date is empty")
    class WrongDateFormatException(date: String) :
        TrackingException("Wrong date format. Was $date, but expecting yyyy-MM-dd'T'HH:mm:ss.SSS")
    class EmptyTextException : TrackingException("Text is empty")
}