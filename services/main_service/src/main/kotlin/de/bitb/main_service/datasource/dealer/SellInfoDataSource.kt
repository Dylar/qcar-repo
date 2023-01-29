package de.bitb.main_service.datasource.dealer

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.firestore.FirestoreApi
import de.bitb.main_service.models.SaleInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val SALE_REPOSITORY_MOCK = "sale_info_database_mock"
const val SALE_REPOSITORY = "sale_info_database"
const val SALE_REPOSITORY_IN_USE = SALE_REPOSITORY

interface SaleInfoDataSource {
    fun getSaleInfo(key: String): SaleInfo?

    fun addSaleInfo(info: SaleInfo)
}

@Component
class SaleInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<SaleInfo>() {
    override val log: Logger = LoggerFactory.getLogger(SaleInfoFirestoreApi::class.java)

    override fun getDocumentPath(obj: SaleInfo): String {
        return "${getCollectionPath(obj.dealer, obj.seller, obj.model)}/${obj.key}"
    }

    fun getCollectionPath(dealer: String, seller: String, model: String): String {
        return "dealer/$dealer/seller/$seller/sales"
    }

    fun keyCollection(): String = "sales"
}

@Repository(SALE_REPOSITORY)
class DBSaleInfoDataSource @Autowired constructor(
    val firestoreApi: SaleInfoFirestoreApi,
) : SaleInfoDataSource {

    override fun getSaleInfo(key: String): SaleInfo? {
        return firestoreApi.findDocumentInCollection(firestoreApi.keyCollection()) {
            it.whereEqualTo("key", key)
        }
    }

    override fun addSaleInfo(info: SaleInfo) {
        firestoreApi.writeDocument(info)
    }
}