package de.bitb.main_service

import java.io.File

fun loadJsonFile(name: String) : String = File(name).readText()