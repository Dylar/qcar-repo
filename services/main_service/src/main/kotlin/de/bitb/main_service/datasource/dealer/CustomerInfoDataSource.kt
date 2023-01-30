package de.bitb.main_service.datasource.dealer

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.firestore.FirestoreApi
import de.bitb.main_service.models.CustomerInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

//const val CUSTOMER_INFO_REPOSITORY_MOCK = "customer_info_database_mock"
const val CUSTOMER_REPOSITORY = "customer_info_database"
const val CUSTOMER_REPOSITORY_IN_USE = CUSTOMER_REPOSITORY

interface CustomerInfoDataSource {
    fun getCustomers(dealer: String): List<CustomerInfo>?
    fun addCustomer(customer: CustomerInfo)
}

@Component
class CustomerInfoFirestoreApi(override val firestore: Firestore) : FirestoreApi<CustomerInfo>() {
    override val log: Logger = LoggerFactory.getLogger(CustomerInfoFirestoreApi::class.java)

    override fun getDocumentPath(obj: CustomerInfo): String =
        getCollectionPath(obj.dealer)+"/${obj.name}_${obj.lastName}_${obj.birthday}"

    fun getCollectionPath(dealer: String): String = "dealer/${dealer}/customers"
}

@Repository(CUSTOMER_REPOSITORY)
class DBCustomerInfoDataSource @Autowired constructor(
    val firestoreApi: CustomerInfoFirestoreApi,
) : CustomerInfoDataSource {
    val log: Logger = LoggerFactory.getLogger(DBCustomerInfoDataSource::class.java)

    override fun getCustomers(dealer: String): List<CustomerInfo>? {
        val path = firestoreApi.getCollectionPath(dealer)
        return firestoreApi.getCollection(path)
    }

    override fun addCustomer(customer: CustomerInfo) {
        firestoreApi.writeDocument(customer)
    }

}