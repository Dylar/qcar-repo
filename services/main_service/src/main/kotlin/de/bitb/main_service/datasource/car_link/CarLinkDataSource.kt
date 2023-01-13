package de.bitb.main_service.datasource.car_link

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.FirestoreApi
import de.bitb.main_service.models.CarLink
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val CAR_LINK_REPOSITORY_MOCK = "car_link_database_mock"
const val CAR_LINK_REPOSITORY = "car_link_database"
const val CAR_LINK_REPOSITORY_IN_USE = CAR_LINK_REPOSITORY

interface CarLinkDataSource {
    fun getLinks(dealer: String): List<CarLink>?
    fun addLink(link: CarLink)
}

@Component
class CarLinkFirestoreApi(override val firestore: Firestore) : FirestoreApi<CarLink>() {
    override val log: Logger = LoggerFactory.getLogger(CarLinkFirestoreApi::class.java)

    override fun getDocumentPath(obj: CarLink): String {
        return getCollectionPath(obj.dealer) //TODO wrong?
    }

    fun getCollectionPath(dealer: String): String {
        return "dealer/${dealer}/cars"
    }
}

@Repository(CAR_LINK_REPOSITORY)
class DBCarLinkDataSource @Autowired constructor(
    val firestoreApi: CarLinkFirestoreApi,
) : CarLinkDataSource {
    val log: Logger = LoggerFactory.getLogger(DBCarLinkDataSource::class.java)

    override fun getLinks(dealer: String): List<CarLink>? {
        val path = firestoreApi.getCollectionPath(dealer)
        return firestoreApi.readCollection(path)
    }

    override fun addLink(link: CarLink) {
        firestoreApi.writeDocument(link)
    }

}