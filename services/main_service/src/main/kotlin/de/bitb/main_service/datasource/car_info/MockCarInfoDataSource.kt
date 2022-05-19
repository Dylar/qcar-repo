package de.bitb.main_service.datasource.car_info

import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository("car_info_database_mock")
class MockCarInfoDataSource : CarInfoDataSource {

    private val carInfoDB = mutableListOf<CarInfo>()
    private val techInfoDB = mutableListOf<TechInfo>()

    override fun getCarInfo(brand: String, model: String): CarInfo? =
            carInfoDB.find { it.brand == brand && it.model == model }

    override fun addCarInfo(info: CarInfo) {
        if (carInfoDB.contains(info)) {
            carInfoDB.replaceAll {
                if (it.brand == info.brand && it.model == info.model) info
                else it
            }
        } else {
            carInfoDB.add(info)
        }
    }

    override fun getTechInfo(brand: String, model: String): TechInfo? =
            techInfoDB.find { it.brand == brand && it.model == model }

    override fun addTechInfo(info: TechInfo) {
        if (techInfoDB.contains(info)) {
            techInfoDB.replaceAll {
                if (it.brand == info.brand && it.model == info.model) info
                else it
            }
        } else {
            techInfoDB.add(info)
        }
    }

}