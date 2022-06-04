package de.bitb.main_service.models

import de.bitb.main_service.exceptions.*

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

fun validateTechInfo(info: TechInfo) {
    if (info.brand.isBlank()) {
        throw TechInfoException.EmptyBrandException()
    }
    if (info.model.isBlank()) {
        throw TechInfoException.EmptyModelException()
    }
}

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

fun validateSellInfo(info: SellInfo) {
    if (info.brand.isBlank()) {
        throw SellInfoException.EmptyBrandException()
    }
    if (info.model.isBlank()) {
        throw SellInfoException.EmptyModelException()
    }
    if (info.seller.isBlank()) {
        throw SellInfoException.EmptySellerException()
    }
    if (info.carDealer.isBlank()) {
        throw SellInfoException.EmptyCarDealerException()
    }
    if (info.key.isBlank()) {
        throw SellInfoException.EmptyKeyException()
    }
}