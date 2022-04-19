package de.bitb.main_service.datasource.car_info

import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.ConfigData
import de.bitb.main_service.models.Configuration
import org.springframework.stereotype.Repository

interface CarInfoDataSource {
    fun getCarInfo(brand:String, model:String) : CarInfo

    fun addCarInfo(carInfo: CarInfo)
}

@Repository("car_info_database")
class DBCarInfoDataSource : CarInfoDataSource {
    override fun getCarInfo(brand: String, model: String): CarInfo {
        TODO("Not yet implemented")
    }

    override fun addCarInfo(carInfo: CarInfo) {
        TODO("Not yet implemented")
    }
}