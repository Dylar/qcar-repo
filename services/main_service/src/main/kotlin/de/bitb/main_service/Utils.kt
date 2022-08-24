package de.bitb.main_service

import java.io.File
import java.time.LocalDate
import java.time.format.DateTimeFormatter

fun loadJsonFile(name: String): String = File(name).readText()

fun parseDateString(date: String): LocalDate =
    LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS"))