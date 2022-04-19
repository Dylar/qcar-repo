package de.bitb.main_service.datasource.car_info

import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository("car_info_database_mock")
class MockCarInfoDataSource : CarInfoDataSource {

    private val carInfoDB = mutableListOf<CarInfo>()

    override fun getCarInfo(brand: String, model: String): CarInfo =
            carInfoDB.find { it.brand == brand && it.model == model }
                    ?: throw CarInfoException.UnknownCarException(brand, model)

    override fun addCarInfo(carInfo: CarInfo) {
        carInfoDB.replaceAll { if (it.brand == carInfo.brand && it.model == carInfo.model) carInfo else it }
    }

}