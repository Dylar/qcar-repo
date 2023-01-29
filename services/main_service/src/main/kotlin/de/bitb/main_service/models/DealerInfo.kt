package de.bitb.main_service.models

data class DealerInfo(
    val name: String = "",
    val address: String = ""
)

data class CarLink(
    val dealer: String = "",
    val brand: String = "",
    val model: String = "",
)

data class SellerInfo(
    val dealer: String = "",
    val name: String = "",
)

data class SaleInfo(
    val brand: String = "",
    val model: String = "",
    val seller: String = "",
    val dealer: String = "",
    val key: String = "",
    val intro: String = "",
    val videos: Map<String, List<String>> = mapOf(),
)

