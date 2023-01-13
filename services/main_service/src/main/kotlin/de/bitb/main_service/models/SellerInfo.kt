package de.bitb.main_service.models

data class DealerInfo(
    val name: String = "",
    val address: String = "",
    val cars:List<CarInfo> = mutableListOf(),
)

data class SellerInfo(
    val dealer: String = "",
    val name: String = "",
)
