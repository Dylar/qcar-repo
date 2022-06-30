package de.bitb.main_service.models

data class SellInfo(
    val brand: String = "",
    val model: String = "",
    val seller: String = "",
    val dealer: String = "",
    val key: String = "",
    val videos: List<SellVideo> = listOf()
)

data class SellVideo(
    val category: String = "",
    val name: String = "",
)
