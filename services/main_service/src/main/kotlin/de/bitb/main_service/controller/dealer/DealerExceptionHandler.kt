package de.bitb.main_service.controller.dealer

import de.bitb.main_service.controller.BaseExceptionHandler
import de.bitb.main_service.exceptions.CarLinkException
import de.bitb.main_service.exceptions.DealerInfoException
import de.bitb.main_service.exceptions.SaleInfoException
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

    @ExceptionHandler(CarLinkException.NoCarLinksException::class)
    fun handleException(e: CarLinkException.NoCarLinksException): ResponseEntity<String> =
        notFound(e.message!!)

    // SELLER
    @ExceptionHandler(SellerInfoException::class)
    fun handleException(e: SellerInfoException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(SellerInfoException.UnknownSellerException::class)
    fun handleException(e: SellerInfoException.UnknownSellerException): ResponseEntity<String> =
        notFound(e.message!!)

    // SELL
    @ExceptionHandler(SaleInfoException::class)
    fun handleException(e: SaleInfoException): ResponseEntity<String> = badRequest(e.message!!)

    @ExceptionHandler(SaleInfoException.UnknownKeyException::class)
    fun handleException(e: SaleInfoException.UnknownKeyException): ResponseEntity<String> =
        notFound(e.message!!)

}