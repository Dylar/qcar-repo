package de.bitb.main_service.models

import de.bitb.main_service.parseDateString
import java.time.ZonedDateTime

data class Feedback(val date: String = "", val text: String = "") {
    fun dateAsDateTime(): ZonedDateTime = parseDateString(date)
}