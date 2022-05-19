package de.bitb.main_service.models

data class CarInfo(
        val brand: String,
        val model: String,
        val imagePath: String,
)

data class CategoryInfo(
        val name: String,
        val order: String,
        val description: String,
        val imagePath: String,
)

data class VideoInfo(
        val brand: String,
        val model: String,
        val category: String,
        val name: String,
        val description: String,
        val filePath: String,
        val imagePath: String,
        val tags: List<String>
)

data class TechInfo(val brand: String, val model: String)