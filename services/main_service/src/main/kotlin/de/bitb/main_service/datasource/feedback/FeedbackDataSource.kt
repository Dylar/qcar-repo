package de.bitb.main_service.datasource.feedback

import de.bitb.main_service.models.Feedback
import org.springframework.stereotype.Repository

const val FEEDBACK_REPOSITORY_MOCK = "feedback_database_mock"
const val FEEDBACK_REPOSITORY = "feedback_database"
const val FEEDBACK_REPOSITORY_IN_USE = FEEDBACK_REPOSITORY_MOCK

interface FeedbackDataSource {
    fun getFeedback(): List<Feedback>

    fun addFeedback(feedback: Feedback)
}

@Repository(FEEDBACK_REPOSITORY)
class DBFeedbackDataSource: FeedbackDataSource {
    override fun getFeedback(): List<Feedback> {
        TODO("Not yet implemented")
    }

    override fun addFeedback(feedback: Feedback) {
        TODO("Not yet implemented")
    }
}