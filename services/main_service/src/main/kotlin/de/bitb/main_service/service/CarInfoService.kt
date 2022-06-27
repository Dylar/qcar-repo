package de.bitb.main_service.service

import de.bitb.main_service.datasource.car_info.CAR_REPOSITORY_IN_USE
import de.bitb.main_service.datasource.car_info.CarInfoDataSource
import de.bitb.main_service.datasource.sell_info.SELL_REPOSITORY_IN_USE
import de.bitb.main_service.datasource.sell_info.SellInfoDataSource
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.validateCarInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.bind.annotation.ExceptionHandler

@Service
class CarInfoService @Autowired constructor(
        @Qualifier(CAR_REPOSITORY_IN_USE) val carDS: CarInfoDataSource,
        @Qualifier(SELL_REPOSITORY_IN_USE) val sellDS: SellInfoDataSource
) {
    private val log: Logger = LoggerFactory.getLogger(CarInfoService::class.java)

    @Throws(SellInfoException.UnknownKeyException::class, CarInfoException.UnknownCarException::class)
    fun getSoldCarInfo(key: String): CarInfo {
        log.info("getSoldCarInfo")
        val sellInfo = sellDS.getSellInfo(key) ?: throw SellInfoException.UnknownKeyException(key)
        return carDS.getCarInfo(sellInfo.brand, sellInfo.model)
                ?: throw CarInfoException.UnknownCarException(sellInfo.brand, sellInfo.model)
    }

    @Throws(CarInfoException.UnknownCarException::class)
    fun getCarInfo(brand: String, model: String): CarInfo {
        log.info("getCarInfo")
        return carDS.getCarInfo(brand, model)
                ?: throw CarInfoException.UnknownCarException(brand, model)
    }

    @Throws(CarInfoException::class)
    fun addCarInfo(info: CarInfo) {
        log.info("addCarInfo")
        validateCarInfo(info)
        carDS.addCarInfo(info)
    }

}