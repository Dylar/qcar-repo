package de.bitb.main_service.service

import de.bitb.main_service.datasource.feedback.FEEDBACK_REPOSITORY_IN_USE
import de.bitb.main_service.datasource.feedback.FeedbackDataSource
import de.bitb.main_service.exceptions.FeedbackException
import de.bitb.main_service.models.Feedback
import de.bitb.main_service.models.validateFeedback
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class FeedbackService(
    @Qualifier(FEEDBACK_REPOSITORY_IN_USE) @Autowired val feedbackDS: FeedbackDataSource
) {
    private val log: Logger = LoggerFactory.getLogger(FeedbackService::class.java)

    @Throws(FeedbackException::class)
    fun addFeedback(feedback: Feedback) {
        validateFeedback(feedback)
        feedbackDS.addFeedback(feedback)
    }

    @Throws(FeedbackException.NoFeedbackException::class)
    fun getFeedback(): List<Feedback> =
        feedbackDS.getFeedback().ifEmpty { throw FeedbackException.NoFeedbackException() }

}