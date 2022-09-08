package de.bitb.main_service.models

import de.bitb.main_service.exceptions.*

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

@Throws(SellInfoException::class)
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
    if (info.dealer.isBlank()) {
        throw SellInfoException.EmptyDealerException()
    }
    if (info.key.isNotBlank()) {
        throw SellInfoException.NotEmptyKeyException()
    }
    if (info.intro.isBlank()) {
        throw SellInfoException.EmptyIntroException()
    }
    if (info.videos.isEmpty()) {
        throw SellInfoException.NoVideosException()
    }
    info.videos.forEach {
        if (it.value.isEmpty()) {
            throw SellInfoException.NoVideosForCategoryException(it.key)
        }
    }
}

@Throws(SellerInfoException::class)
fun validateSellerInfo(info: SellerInfo) {
    if (info.dealer.isBlank()) {
        throw SellerInfoException.EmptyDealerException()
    }
    if (info.name.isBlank()) {
        throw SellerInfoException.EmptySellerException()
    }
}

@Throws(FeedbackException::class)
fun validateFeedback(feedback: Feedback) {
    if (feedback.date.isBlank()) {
        throw FeedbackException.EmptyDateException()
    }
    try{
        feedback.dateAsDateTime()
    }catch (e: Exception){
        throw FeedbackException.WrongDateFormatException(feedback.date)
    }
    if (feedback.text.isBlank()) {
        throw FeedbackException.EmptyTextException()
    }
}

@Throws(TrackingException::class)
fun validateTracking(feedback: Tracking) {
    if (feedback.date.isBlank()) {
        throw TrackingException.EmptyDateException()
    }
    try{
        feedback.dateAsDateTime()
    }catch (e: Exception){
        throw TrackingException.WrongDateFormatException(feedback.date)
    }
    if (feedback.text.isBlank()) {
        throw TrackingException.EmptyTextException()
    }
}