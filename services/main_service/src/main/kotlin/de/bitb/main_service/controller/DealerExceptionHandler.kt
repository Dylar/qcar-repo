package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.CarLinkException
import de.bitb.main_service.exceptions.DealerInfoException
import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.exceptions.SellerInfoException
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler

@ControllerAdvice(basePackageClasses = [DealerController::class])
class DealerExceptionHandler : BaseExceptionHandler() {
    override val log: Logger = LoggerFactory.getLogger(DealerExceptionHandler::class.java)

    // DEALER
    @ExceptionHandler(DealerInfoException::class)
    fun handleException(e: DealerInfoException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(DealerInfoException.UnknownDealerException::class)
    fun handleException(e: DealerInfoException.UnknownDealerException): ResponseEntity<String> =
        notFound(e.message!!)

    // CARS
    @ExceptionHandler(CarLinkException::class)
    fun handleException(e: CarLinkException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(CarLinkException.NoCarLinkException::class)
    fun handleException(e: CarLinkException.NoCarLinkException): ResponseEntity<String> =
        notFound(e.message!!)

    // SELLER
    @ExceptionHandler(SellerInfoException::class)
    fun handleException(e: SellerInfoException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(SellerInfoException.UnknownSellerException::class)
    fun handleException(e: SellerInfoException.UnknownSellerException): ResponseEntity<String> =
        notFound(e.message!!)

    // SELL
    @ExceptionHandler(SellInfoException::class)
    fun handleException(e: SellInfoException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(SellInfoException.UnknownKeyException::class)
    fun handleException(e: SellInfoException.UnknownKeyException): ResponseEntity<String> =
        notFound(e.message!!)

}