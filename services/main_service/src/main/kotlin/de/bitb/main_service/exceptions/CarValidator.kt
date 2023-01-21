package de.bitb.main_service.exceptions

import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.CategoryInfo
import de.bitb.main_service.models.VideoInfo

@Throws(CarInfoException::class)
fun validateCarInfo(info: CarInfo) {
    if (info.brand.isBlank()) {
        throw CarInfoException.EmptyBrandException()
    }
    if (info.model.isBlank()) {
        throw CarInfoException.EmptyModelException()
    }
    if (info.imagePath.isBlank()) {
        throw CarInfoException.EmptyImagePathException()
    }
}

@Throws(CategoryInfoException::class)
fun validateCategoryInfo(info: CategoryInfo) {
    if (info.brand.isBlank()) {
        throw CategoryInfoException.EmptyBrandException()
    }
    if (info.model.isBlank()) {
        throw CategoryInfoException.EmptyModelException()
    }
    if (info.name.isBlank()) {
        throw CategoryInfoException.EmptyNameException()
    }
    if (info.description.isBlank()) {
        throw CategoryInfoException.EmptyDescriptionException()
    }
    if (info.imagePath.isBlank()) {
        throw CategoryInfoException.EmptyImagePathException()
    }
}

@Throws(VideoInfoException::class)
fun validateVideoInfo(info: VideoInfo) {
    if (info.brand.isBlank()) {
        throw VideoInfoException.EmptyBrandException()
    }
    if (info.model.isBlank()) {
        throw VideoInfoException.EmptyModelException()
    }
    if (info.category.isBlank()) {
        throw VideoInfoException.EmptyCategoryException()
    }
    if (info.name.isBlank()) {
        throw VideoInfoException.EmptyNameException()
    }
    if (info.description.isBlank()) {
        throw VideoInfoException.EmptyDescriptionException()
    }
    if (info.imagePath.isBlank()) {
        throw VideoInfoException.EmptyImagePathException()
    }
    if (info.filePath.isBlank()) {
        throw VideoInfoException.EmptyFilePathException()
    }
    if (info.tags.isEmpty() || info.tags.all { it.isBlank() }) {
        throw VideoInfoException.EmptyTagsException()
    }
}
