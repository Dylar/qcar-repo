package de.bitb.main_service.models

import de.bitb.main_service.parseDateString
import java.time.LocalDate

data class Feedback(val date: String = "", val text: String = "") {
    fun dateAsDateTime(): LocalDate = parseDateString(date)
}