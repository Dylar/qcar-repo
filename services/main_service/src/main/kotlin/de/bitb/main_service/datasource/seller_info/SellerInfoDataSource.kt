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
        return getDocumentPath(obj.dealer,obj.name)
    }

    fun getDocumentPath(dealer: String, name:String): String {
        return "dealer/$dealer/seller/$name"
    }
}

@Repository(SELLER_REPOSITORY)
class DBSellerInfoDataSource @Autowired constructor(
    val firestoreApi: SellerInfoFirestoreApi,
) : SellerInfoDataSource {

    override fun getSellerInfo(dealer: String, name :String): SellerInfo? {
        val path = firestoreApi.getDocumentPath(dealer, name)
        return firestoreApi.readDocument(path)
    }

    override fun addSellerInfo(info: SellerInfo) {
        firestoreApi.writeDocument(info)
    }
}