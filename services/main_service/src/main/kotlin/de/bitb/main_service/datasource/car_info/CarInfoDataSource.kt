package de.bitb.main_service.datasource.car_info

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.FirestoreApi
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.TechInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val CAR_REPOSITORY_MOCK = "car_info_database_mock"
const val CAR_REPOSITORY = "car_info_database"
const val CAR_REPOSITORY_IN_USE = CAR_REPOSITORY

interface CarInfoDataSource {
    fun getCarInfo(brand: String, model: String): CarInfo?
    fun addCarInfo(info: CarInfo)

    fun getTechInfo(brand: String, model: String): TechInfo?
    fun addTechInfo(info: TechInfo)
}

@Component
class CarInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<CarInfo>() {
    override val log: Logger = LoggerFactory.getLogger(CarInfoFirestoreApi::class.java)

    override val collectionName: String = "car_info"
}

@Component
class TechInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<TechInfo>() {
    override val log: Logger = LoggerFactory.getLogger(TechInfoFirestoreApi::class.java)

    override val collectionName: String = "tech_info"
}

@Repository(CAR_REPOSITORY)
class DBCarInfoDataSource @Autowired constructor(
    val carFirestoreApi: CarInfoFirestoreApi,
    val techFirestoreApi: TechInfoFirestoreApi
) : CarInfoDataSource {
    val log: Logger = LoggerFactory.getLogger(DBCarInfoDataSource::class.java)

    private fun getPath(brand: String, model: String): String {
        return "$brand/$model"
    }

    override fun getCarInfo(brand: String, model: String): CarInfo? {
        log.info("getCarInfo")
        val path = getPath(brand, model)
        return carFirestoreApi.readDocument(path)
    }

    override fun addCarInfo(info: CarInfo) {
        log.info("addCarInfo")
        val path = getPath(info.brand, info.model)
        carFirestoreApi.writeDocument(path, info)
    }

    override fun getTechInfo(brand: String, model: String): TechInfo? {
        val path = getPath(brand, model)
        return techFirestoreApi.readDocument(path)
    }

    override fun addTechInfo(info: TechInfo) {
        val path = getPath(info.brand, info.model)
        techFirestoreApi.writeDocument(path, info)
    }
}