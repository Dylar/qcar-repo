package de.bitb.main_service.models

data class SellerInfo(
    val dealer: String = "",
    val name: String = "",
)

data class IntroInfo(
    val dealer: String = "",
    val seller: String = "",
    val brand: String = "",
    val model: String = "",
    val filePath: String = "",
)
