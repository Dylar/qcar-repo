package de.bitb.main_service.exceptions

sealed class CarInfoException(msg: String) : Exception(msg) {
    class UnknownCarException(brand: String, model: String) :
        CarInfoException("Unknown car - $brand, $model")

    class EmptyBrandException : CarInfoException("Brand is empty")
    class EmptyModelException : CarInfoException("Model is empty")
    class EmptyImagePathException : CarInfoException("Image path is empty")
}

sealed class CategoryInfoException(msg: String) : Exception(msg) {
    class UnknownCategoryException(name: String) : CategoryInfoException("Unknown category: $name")
    class EmptyBrandException : CategoryInfoException("Brand is empty")
    class EmptyModelException : CategoryInfoException("Model is empty")
    class EmptyNameException : CategoryInfoException("Name is empty")
    class EmptyDescriptionException : CategoryInfoException("Description is empty")
    class EmptyImagePathException : CategoryInfoException("Image path is empty")
}

sealed class VideoInfoException(msg: String) : Exception(msg) {
    class UnknownVideoException(brand: String, model: String, name: String) :
        VideoInfoException("Unknown video: $name, for $brand - $model")

    class EmptyBrandException : VideoInfoException("Brand is empty")
    class EmptyModelException : VideoInfoException("Model is empty")
    class EmptyCategoryException : VideoInfoException("Category is empty")
    class EmptyNameException : VideoInfoException("Name is empty")
    class EmptyDescriptionException : VideoInfoException("Description is empty")
    class EmptyFilePathException : VideoInfoException("File path is empty")
    class EmptyImagePathException : VideoInfoException("Image path is empty")
    class EmptyTagsException : VideoInfoException("No tags found")
}

sealed class TechInfoException(msg: String) : Exception(msg) {
    class UnknownCarException(brand: String, model: String) :
        TechInfoException("Unknown car - $brand, $model")

    class EmptyBrandException : TechInfoException("Brand is empty")
    class EmptyModelException : TechInfoException("Model is empty")
}