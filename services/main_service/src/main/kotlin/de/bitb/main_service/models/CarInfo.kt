package de.bitb.main_service.models

data class CarInfo(
        val brand: String,
        val model: String,
        val imagePath: String,
        val categories: List<CategoryInfo>
)

data class CategoryInfo(
        val name: String,
        val order: String,
        val description: String,
        val imagePath: String,
        val videos: List<VideoInfo>
)

data class VideoInfo(
        val name: String,
        val filePath: String,
        val imagePath: String,
        val description: String,
        val tags: List<String>
)