package de.bitb.main_service.controller

import de.bitb.main_service.models.*
import de.bitb.main_service.service.SellInfoService
import de.bitb.main_service.service.SellerInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(DEALER_URL_V1)
class DealerController @Autowired constructor(
    private val service: SellerInfoService,
    private val sellService: SellInfoService
) {
    private val log: Logger = LoggerFactory.getLogger(DealerController::class.java)

    // DEALER
    @GetMapping("/dealer/{name}")
    fun getDealerInfo(@PathVariable name: String): DealerInfo {
        log.info("getDealerInfo: $name") //TODO test me
        return service.getDealerInfo(name)
    }

    @PostMapping("/addDealer")
    @ResponseStatus(HttpStatus.CREATED)
    fun addDealerInfo(@RequestBody info: DealerInfo) {
        log.info("addDealerInfo: $info")
        service.addDealerInfo(info)
    }

    //SELLER
    @GetMapping("/dealer/{dealer}/seller/{name}")
    fun getSellerInfo(@PathVariable dealer: String, @PathVariable name: String): SellerInfo {
        log.info("getSellerInfo: $dealer - $name")
        return service.getSellerInfo(dealer, name)
    }

    @PostMapping("/addSeller")
    @ResponseStatus(HttpStatus.CREATED)
    fun addSellerInfo(@RequestBody info: SellerInfo) {
        log.info("addSellerInfo: $info") //TODO
        service.addSellerInfo(info)
    }

    // CARS
    @GetMapping("/getCars/{dealer}")
    fun getCarInfos(@PathVariable dealer: String): List<CarInfo> {
        log.info("getCarInfos") //TODO test me
        return service.getCarInfos(dealer)
    }

    @PostMapping("/linkCar")
    @ResponseStatus(HttpStatus.CREATED)
    fun linkCarToDealer(@RequestBody info: CarLink) {
        log.info("linkCarToDealer") //TODO test me
        service.linkCarToDealer(info)
    }

    // SELL
    @GetMapping("(/{key}")
    fun getSellInfo(@PathVariable key: String): SellInfo {
        log.info("getSellInfo: $key")
        return sellService.getSellInfo(key)
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addSellInfo(@RequestBody info: SellInfo) {
        log.info("addSellInfo: $info")
        sellService.addSellInfo(info)
    }

}