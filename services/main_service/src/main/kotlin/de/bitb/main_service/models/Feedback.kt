package de.bitb.main_service.models

import de.bitb.main_service.parseDateString
import java.time.LocalDate

data class Feedback(
    val customerName: String = "",
    val date: String = "",
    val text: String = "",
    val rating: Int = 0,
) {
    fun dateAsDateTime(): LocalDate = parseDateString(date)
}