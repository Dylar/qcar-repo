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

    override fun getDocumentPath(obj: CarInfo): String {
        return "${getCollectionPath(obj.brand)}/${obj.model}"
    }

    fun getCollectionPath(brand: String): String {
        return "car/${brand}"
    }
}

@Component
class TechInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<TechInfo>() {
    override val log: Logger = LoggerFactory.getLogger(TechInfoFirestoreApi::class.java)

    override fun getDocumentPath(obj: TechInfo): String {
        return "${getCollectionPath(obj.brand)}/${obj.model}"
    }

    fun getCollectionPath(brand: String): String {
        return "car/${brand}"
    }
}

@Repository(CAR_REPOSITORY)
class DBCarInfoDataSource @Autowired constructor(
    val carFirestoreApi: CarInfoFirestoreApi,
    val techFirestoreApi: TechInfoFirestoreApi
) : CarInfoDataSource {
    val log: Logger = LoggerFactory.getLogger(DBCarInfoDataSource::class.java)

    override fun getCarInfo(brand: String, model: String): CarInfo? {
        val path = carFirestoreApi.getCollectionPath(brand)
        return carFirestoreApi.readDocument(path) {
            it.whereEqualTo("model", model)
        }
    }

    override fun addCarInfo(info: CarInfo) {
        carFirestoreApi.writeDocument(info)
    }

    override fun getTechInfo(brand: String, model: String): TechInfo? {
        val path = techFirestoreApi.getCollectionPath(brand)
        return techFirestoreApi.readDocument(path) {
            it.whereEqualTo("model", model)
        }
    }

    override fun addTechInfo(info: TechInfo) {
        techFirestoreApi.writeDocument(info)
    }
}