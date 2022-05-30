package de.bitb.main_service.datasource.car_info

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(CAR_REPOSITORY_MOCK)
class MockCarInfoDataSource : CarInfoDataSource {
    private val log: Logger = LoggerFactory.getLogger(MockCarInfoDataSource::class.java)

    private val carInfoDB = mutableListOf<CarInfo>()
    private val techInfoDB = mutableListOf<TechInfo>()

    override fun getCarInfo(brand: String, model: String): CarInfo? {
        log.info("getCarInfo")
        return carInfoDB.find { it.brand == brand && it.model == model }
    }

    override fun addCarInfo(info: CarInfo) {
        log.info("addCarInfo")
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