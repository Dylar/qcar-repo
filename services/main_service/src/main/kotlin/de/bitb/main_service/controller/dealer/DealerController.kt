package de.bitb.main_service.controller.dealer

import de.bitb.main_service.controller.DEALER_URL_V1
import de.bitb.main_service.models.*
import de.bitb.main_service.service.DealerInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(DEALER_URL_V1)
class DealerController @Autowired constructor(
    private val service: DealerInfoService
) {
    private val log: Logger = LoggerFactory.getLogger(DealerController::class.java)

    // DEALER
    @GetMapping("/dealer/{name}")
    fun getDealerInfo(@PathVariable name: String): DealerInfo {
        log.info("getDealerInfo: $name")
        return service.getDealerInfo(name)
    }
//    V2VubkR1RGFzRW50c2NobMO8c3NlbHN0TWF4aSxiaXN0ZVNjaG9uR3V0OlAK

    @PostMapping("/dealer")
    @ResponseStatus(HttpStatus.CREATED)
    fun addDealerInfo(@RequestBody info: DealerInfo) {
        log.info("addDealerInfo: $info")
        service.addDealerInfo(info)
    }

    // CARS
    @GetMapping("/cars/{dealer}")
    fun getCarInfos(@PathVariable dealer: String): List<CarInfo> {
        log.info("getCarInfos")
        return service.getCarInfos(dealer)
    }

    @PostMapping("/car")
    @ResponseStatus(HttpStatus.CREATED)
    fun linkCarToDealer(@RequestBody info: CarLink) {
        log.info("linkCarToDealer")
        service.linkCarToDealer(info)
    }

    //SELLER
    @GetMapping("/dealer/{dealer}/seller/{name}")
    fun getSellerInfo(@PathVariable dealer: String, @PathVariable name: String): SellerInfo {
        log.info("getSellerInfo: $dealer - $name")
        return service.getSellerInfo(dealer, name)
    }

    @PostMapping("/seller")
    @ResponseStatus(HttpStatus.CREATED)
    fun addSellerInfo(@RequestBody info: SellerInfo) {
        log.info("addSellerInfo: $info")
        service.addSellerInfo(info)
    }

    // SALE
    @GetMapping("/sale/{key}")
    fun getSaleInfo(@PathVariable key: String): SaleInfo {
        log.info("getSaleInfo: $key")
        return service.getSaleInfo(key)
    }

    @PostMapping("/sale")
    @ResponseStatus(HttpStatus.CREATED)
    fun addSaleInfo(@RequestBody info: SaleInfo) {
        log.info("addSaleInfo: $info")
        service.addSaleInfo(info)
    }

    // CUSTOMER
    @GetMapping("/customers/{dealer}")
    fun getCustomerInfos(@PathVariable dealer: String): List<CustomerInfo> {
        log.info("getCustomerInfos: $dealer")
        return service.getCustomerInfos(dealer)
    }

    @PostMapping("/customer")
    @ResponseStatus(HttpStatus.CREATED)
    fun addCustomerInfo(@RequestBody info: CustomerInfo) {
        log.info("addCustomerInfo: $info")
        service.addCustomerInfo(info)
    }

}