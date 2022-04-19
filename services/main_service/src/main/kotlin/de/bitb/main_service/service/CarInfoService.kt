package de.bitb.main_service.service

import de.bitb.main_service.datasource.car_info.CarInfoDataSource
import de.bitb.main_service.datasource.sell_info.SellInfoDataSource
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.ConfigData
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class CarInfoService(
        @Qualifier("car_info_database_mock") @Autowired val carDS: CarInfoDataSource,
        @Qualifier("sell_info_database_mock") @Autowired val sellDS: SellInfoDataSource
) {

    fun getCarInfo(key: String): CarInfo {
        val sellInfo = sellDS.getSellInfo(key);
        return carDS.getCarInfo(sellInfo.brand, sellInfo.model)
    }

    fun addCarInfo(info: CarInfo) {
        carDS.addCarInfo(info)
    }
}