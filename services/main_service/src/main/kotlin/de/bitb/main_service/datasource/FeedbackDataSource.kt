package de.bitb.main_service.datasource

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.firestore.FirestoreApi
import de.bitb.main_service.models.Feedback
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val FEEDBACK_REPOSITORY_MOCK = "feedback_database_mock"
const val FEEDBACK_REPOSITORY = "feedback_database"
const val FEEDBACK_REPOSITORY_IN_USE = FEEDBACK_REPOSITORY

interface FeedbackDataSource {
    fun getFeedback(customer: String): List<Feedback>

    fun addFeedback(feedback: Feedback)
}

@Component
class FeedbackFirestoreApi(override val firestore: Firestore) : FirestoreApi<Feedback>() {
    override val log: Logger = LoggerFactory.getLogger(FeedbackFirestoreApi::class.java)

    override fun getDocumentPath(obj: Feedback): String {
        return "${getCollectionPath(obj.customerName)}/${obj.date}"
    }

    fun getCollectionPath(name: String): String = "customer/$name/feedback"
}

@Repository(FEEDBACK_REPOSITORY)
class DBFeedbackDataSource @Autowired constructor(
    val firestoreApi: FeedbackFirestoreApi,
) : FeedbackDataSource {

    override fun getFeedback(customer: String): List<Feedback> {
        val path = firestoreApi.getCollectionPath(customer)
        return firestoreApi.getCollection(path)
    }

    override fun addFeedback(feedback: Feedback) {
        firestoreApi.writeDocument(feedback)
    }

}