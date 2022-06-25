package de.bitb.main_service.datasource.category_info

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.FirestoreApi
import de.bitb.main_service.datasource.car_info.CarInfoFirestoreApi
import de.bitb.main_service.datasource.car_info.DBCarInfoDataSource
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.CategoryInfo
import de.bitb.main_service.models.TechInfo
import de.bitb.main_service.models.VideoInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val CATEGORY_REPOSITORY_MOCK = "category_info_database_mock"
const val CATEGORY_REPOSITORY = "category_info_database"
const val CATEGORY_REPOSITORY_IN_USE = CATEGORY_REPOSITORY

interface CategoryInfoDataSource {
    fun getCategoryInfo(brand: String, model: String, name: String): CategoryInfo?

    fun addCategoryInfo(info: CategoryInfo)
}

@Component
class CategoryFirestoreApi(override val firestore: Firestore) : FirestoreApi<CategoryInfo>() {
    override val log: Logger = LoggerFactory.getLogger(CategoryFirestoreApi::class.java)

    override fun getDocumentPath(obj: CategoryInfo): String {
        return "${getCollectionPath(obj.brand, obj.model)}/${obj.name}"
    }

    fun getCollectionPath(brand: String, model: String): String {
        return "car/${brand}/${model}/category"
    }
}

@Repository(CATEGORY_REPOSITORY)
class DBCategoryInfoDataSource @Autowired constructor(
    val firestoreApi: CategoryFirestoreApi,
) : CategoryInfoDataSource {
    override fun getCategoryInfo(brand: String, model: String, name: String): CategoryInfo? {
        val path = firestoreApi.getCollectionPath(brand, model)
        return firestoreApi.readDocument(path) {
            it.whereEqualTo("name", name)
        }
    }

    override fun addCategoryInfo(info: CategoryInfo) {
        firestoreApi.writeDocument(info)
    }

}