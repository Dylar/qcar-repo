package de.bitb.main_service.datasource.tracking

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.FirestoreApi
import de.bitb.main_service.models.Tracking
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val TRACKING_REPOSITORY_MOCK = "tracking_database_mock"
const val TRACKING_REPOSITORY = "tracking_database"
const val TRACKING_REPOSITORY_IN_USE = TRACKING_REPOSITORY

interface TrackingDataSource {
    fun getTracking(): List<Tracking>

    fun addTracking(tracking: Tracking)
}

@Component
class TrackingFirestoreApi(override val firestore: Firestore) : FirestoreApi<Tracking>() {
    override val log: Logger = LoggerFactory.getLogger(TrackingFirestoreApi::class.java)

    override fun getDocumentPath(obj: Tracking): String {
        return "${getCollectionPath()}/${obj.date}"
    }

    fun getCollectionPath(): String {
        return "tracking"
    }
}

@Repository(TRACKING_REPOSITORY)
class DBTrackingDataSource @Autowired constructor(
    val firestoreApi: TrackingFirestoreApi,
) : TrackingDataSource {

    override fun getTracking(): List<Tracking> {
        val path = firestoreApi.getCollectionPath()
        return firestoreApi.readCollection(path)
    }

    override fun addTracking(tracking: Tracking) {
        firestoreApi.writeDocument(tracking)
    }

}