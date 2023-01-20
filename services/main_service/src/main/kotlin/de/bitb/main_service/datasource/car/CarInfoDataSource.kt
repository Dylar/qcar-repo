package de.bitb.main_service.datasource.car

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.firestore.FirestoreApi
import de.bitb.main_service.models.CarInfo
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
}

@Component
class CarInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<CarInfo>() {
    override val log: Logger = LoggerFactory.getLogger(CarInfoFirestoreApi::class.java)

    override fun getDocumentPath(obj: CarInfo): String =
        "${getCollectionPath(obj.brand)}/${obj.model}"

    fun getCollectionPath(brand: String): String = "car/$brand/model"
}

@Repository(CAR_REPOSITORY)
class DBCarInfoDataSource @Autowired constructor(
    val firestoreApi: CarInfoFirestoreApi,
) : CarInfoDataSource {
    val log: Logger = LoggerFactory.getLogger(DBCarInfoDataSource::class.java)

    override fun getCarInfo(brand: String, model: String): CarInfo? {
        val path = firestoreApi.getCollectionPath(brand)
        return firestoreApi.getDocument(path) {
            it.whereEqualTo("brand", brand)
                .whereEqualTo("model", model)
        }
    }

    override fun addCarInfo(info: CarInfo) {
        firestoreApi.writeDocument(info)
    }

}