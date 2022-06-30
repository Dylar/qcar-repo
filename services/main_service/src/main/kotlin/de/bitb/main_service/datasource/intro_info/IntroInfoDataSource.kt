package de.bitb.main_service.datasource.intro_info

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.FirestoreApi
import de.bitb.main_service.models.IntroInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val INTRO_REPOSITORY_MOCK = "intro_info_database_mock"
const val INTRO_REPOSITORY = "intro_info_database"
const val INTRO_REPOSITORY_IN_USE = INTRO_REPOSITORY

interface IntroInfoDataSource {
    fun getIntroInfo(dealer: String, seller: String, brand: String, model: String): IntroInfo?

    fun addIntroInfo(info: IntroInfo)
}

@Component
class IntroFirestoreApi(override val firestore: Firestore) : FirestoreApi<IntroInfo>() {
    override val log: Logger = LoggerFactory.getLogger(IntroFirestoreApi::class.java)

    override fun getDocumentPath(obj: IntroInfo): String {
        return "${getCollectionPath(obj.dealer, obj.seller)}/${obj.brand}_${obj.model}"
    }

    fun getCollectionPath(dealer: String, seller: String): String {
        return "dealer/$dealer/$seller/intros"
    }
}

@Repository(INTRO_REPOSITORY)
class DBIntroInfoInfoDataSource @Autowired constructor(
    val firestoreApi: IntroFirestoreApi,
) : IntroInfoDataSource {
    override fun getIntroInfo(
        dealer: String,
        seller: String,
        brand: String,
        model: String,
    ): IntroInfo? {
        val path = firestoreApi.getCollectionPath(dealer, seller)
        return firestoreApi.readDocument(path) {
            it.whereEqualTo("brand", brand).whereEqualTo("model", model)
        }
    }

    override fun addIntroInfo(info: IntroInfo) {
        firestoreApi.writeDocument(info)
    }
}