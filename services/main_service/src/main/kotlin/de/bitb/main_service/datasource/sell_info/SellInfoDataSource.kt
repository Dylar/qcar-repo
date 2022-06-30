package de.bitb.main_service.datasource.sell_info

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.FirestoreApi
import de.bitb.main_service.models.SellInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val SELL_REPOSITORY_MOCK = "sell_info_database_mock"
const val SELL_REPOSITORY = "sell_info_database"
const val SELL_REPOSITORY_IN_USE = SELL_REPOSITORY

interface SellInfoDataSource {
    fun getSellInfo(key: String): SellInfo?

    fun addSellInfo(info: SellInfo)
}

@Component
class SellInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<SellInfo>() {
    override val log: Logger = LoggerFactory.getLogger(SellInfoFirestoreApi::class.java)

    override fun getDocumentPath(obj: SellInfo): String {
        return "${getCollectionPath(obj.dealer, obj.seller, obj.model)}/${obj.key}"
    }

    fun getCollectionPath(dealer: String, seller: String, model: String): String {
        return "dealer/$dealer/$seller/sales"
    }

    fun keyCollection(): String = "sales"
}

@Repository(SELL_REPOSITORY)
class DBSellInfoDataSource @Autowired constructor(
    val firestoreApi: SellInfoFirestoreApi,
) : SellInfoDataSource {

    override fun getSellInfo(key: String): SellInfo? {
        return firestoreApi.findDocument(firestoreApi.keyCollection()) {
            it.whereEqualTo("key", key)
        }
    }

    override fun addSellInfo(info: SellInfo) {
        firestoreApi.writeDocument(info)
    }
}