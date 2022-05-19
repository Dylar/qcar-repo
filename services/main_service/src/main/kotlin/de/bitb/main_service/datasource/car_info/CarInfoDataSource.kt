package de.bitb.main_service.datasource.car_info

import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.TechInfo
import org.springframework.stereotype.Repository

interface CarInfoDataSource {
    fun getCarInfo(brand:String, model:String) : CarInfo?
    fun addCarInfo(info: CarInfo)

    fun getTechInfo(brand:String, model:String) : TechInfo?
    fun addTechInfo(info: TechInfo)
}

@Repository("car_info_database")
class DBCarInfoDataSource : CarInfoDataSource {
    override fun getCarInfo(brand: String, model: String): CarInfo? {
        TODO("Not yet implemented")
    }

    override fun addCarInfo(info: CarInfo) {
        TODO("Not yet implemented")
    }

    override fun getTechInfo(brand: String, model: String): TechInfo? {
        TODO("Not yet implemented")
    }

    override fun addTechInfo(info: TechInfo) {
        TODO("Not yet implemented")
    }
}