package de.bitb.main_service.exceptions

sealed class DealerInfoException(msg: String) : Exception(msg) {
    class UnknownDealerException(name: String) :
        DealerInfoException("Unknown dealer ($name)")

    class EmptyNameException : DealerInfoException("Dealer name is empty")
    class EmptyAddressException : DealerInfoException("Address is empty")
}

sealed class CarLinkException(msg: String) : Exception(msg) {
    class NoCarLinksException(dealer: String) :
        CarLinkException("Dealer ($dealer) has no cars")

    class EmptyDealerException : CarLinkException("Dealer is empty")
    class EmptyBrandException : CarLinkException("Brand is empty")
    class EmptyModelException : CarLinkException("Model is empty")
}

sealed class SellerInfoException(msg: String) : Exception(msg) {
    class UnknownSellerException(dealer: String, name: String) :
        SellerInfoException("Unknown seller ($name) for dealer ($dealer)")

    class EmptyDealerException : SellerInfoException("Dealer is empty")
    class EmptySellerException : SellerInfoException("Seller is empty")
}

sealed class SaleInfoException(msg: String) : Exception(msg) {
    class UnknownKeyException(msg: String) : SaleInfoException(msg)
    class InvalidKeyException(msg: String) : SaleInfoException(msg)
    class EmptyBrandException : SaleInfoException("Brand is empty")
    class EmptyModelException : SaleInfoException("Model is empty")
    class EmptySellerException : SaleInfoException("Seller is empty")
    class EmptyDealerException : SaleInfoException("Dealer is empty")
    class NotEmptyKeyException : SaleInfoException("Key is NOT empty")
    class EmptyIntroException : SaleInfoException("Intro path empty")
    class NoVideosException : SaleInfoException("No videos")
    class NoVideosForCategoryException(category: String) :
        SaleInfoException("No videos for category $category")
}

sealed class CustomerInfoException(msg: String) : Exception(msg) {
    class UnknownDealerException(msg: String) : CustomerInfoException(msg)

    class EmptyDealerException : CustomerInfoException("Dealer is empty")
    class EmptyNameException : CustomerInfoException("Name is empty")
    class EmptyLastNameException : CustomerInfoException("Last name is empty")
    class EmptyGenderException : CustomerInfoException("Gender is empty")
    class EmptyBirthdayException : CustomerInfoException("Birthday is empty")
    class WrongBirthdayFormatException(date:String) : CustomerInfoException("Wrong birthday format ($date)")
    class EmptyPhoneException : CustomerInfoException("Phone is empty")
    class EmptyEmailException : CustomerInfoException("Email is empty")
}