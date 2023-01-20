package de.bitb.main_service.datasource

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(FEEDBACK_REPOSITORY_MOCK)
class FeedbackDataSourceMock : FeedbackDataSource {

    private val log: Logger = LoggerFactory.getLogger(FeedbackDataSourceMock::class.java)

    private val feedbackDb = mutableListOf<Feedback>()

    override fun getFeedback(customer: String): List<Feedback> = feedbackDb

    override fun addFeedback(feedback: Feedback) {
        feedbackDb.add(feedback)
    }

}