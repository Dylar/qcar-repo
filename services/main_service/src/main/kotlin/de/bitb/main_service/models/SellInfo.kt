package de.bitb.main_service.models

data class SellInfo(
    val brand: String = "",
    val model: String = "",
    val seller: String = "",
    val dealer: String = "",
    val key: String = "",
    val intro: String = "",
    val videos: Map<String, List<String>> = mapOf(),
)
