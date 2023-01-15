package de.bitb.main_service.datasource.dealer

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.firestore.FirestoreApi
import de.bitb.main_service.models.DealerInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val DEALER_REPOSITORY_MOCK = "dealer_info_database_mock"
const val DEALER_REPOSITORY = "dealer_info_database"
const val DEALER_REPOSITORY_IN_USE = DEALER_REPOSITORY

interface DealerInfoDataSource {
    fun getDealerInfo(name: String): DealerInfo?

    fun addDealerInfo(info: DealerInfo)
}

@Component
class DealerInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<DealerInfo>() {
    override val log: Logger = LoggerFactory.getLogger(DealerInfoFirestoreApi::class.java)

    override fun getDocumentPath(obj: DealerInfo): String = "${getCollectionPath()}/${obj.name}"

    fun getCollectionPath(): String = "dealer"
}

@Repository(DEALER_REPOSITORY)
class DBDealerInfoDataSource @Autowired constructor(
    val firestoreApi: DealerInfoFirestoreApi,
) : DealerInfoDataSource {

    override fun getDealerInfo(name: String): DealerInfo? {
        val path = firestoreApi.getCollectionPath()
        return firestoreApi.readDocument(path) {
            it.whereEqualTo("name", name)
        }
    }

    override fun addDealerInfo(info: DealerInfo) {
        firestoreApi.writeDocument(info)
    }
}