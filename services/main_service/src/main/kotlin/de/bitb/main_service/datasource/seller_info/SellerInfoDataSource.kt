package de.bitb.main_service.datasource.seller_info

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.FirestoreApi
import de.bitb.main_service.models.SellerInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val SELLER_REPOSITORY_MOCK = "seller_info_database_mock"
const val SELLER_REPOSITORY = "seller_info_database"
const val SELLER_REPOSITORY_IN_USE = SELLER_REPOSITORY

interface SellerInfoDataSource {
    fun getSellerInfo(dealer: String, name: String): SellerInfo?

    fun addSellerInfo(info: SellerInfo)
}

@Component
class SellerInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<SellerInfo>() {
    override val log: Logger = LoggerFactory.getLogger(SellerInfoFirestoreApi::class.java)

    override fun getDocumentPath(obj: SellerInfo): String {
        return "${getCollectionPath(obj.dealer)}/${obj.name}"
    }

    fun getCollectionPath(dealer: String): String {
        return "dealer/$dealer"
    }
}

@Repository(SELLER_REPOSITORY)
class DBSellerInfoDataSource @Autowired constructor(
    val firestoreApi: SellerInfoFirestoreApi,
) : SellerInfoDataSource {

    override fun getSellerInfo(dealer: String, name :String): SellerInfo? {
        return firestoreApi.findDocument(dealer) {
            it.whereEqualTo("name", name)
        }
    }

    override fun addSellerInfo(info: SellerInfo) {
        firestoreApi.writeDocument(info)
    }
}