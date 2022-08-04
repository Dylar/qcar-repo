package de.bitb.main_service

import java.io.File
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter

fun loadJsonFile(name: String) : String = File(name).readText()

fun parseDateString(date:String) : ZonedDateTime = ZonedDateTime.parse(date, DateTimeFormatter.ISO_OFFSET_DATE_TIME)