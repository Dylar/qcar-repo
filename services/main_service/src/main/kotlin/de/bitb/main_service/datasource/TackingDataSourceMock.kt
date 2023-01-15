package de.bitb.main_service.datasource.tracking

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(TRACKING_REPOSITORY_MOCK)
class MockTrackingDataSource : TrackingDataSource {

    private val log: Logger = LoggerFactory.getLogger(MockTrackingDataSource::class.java)

    private val feedbackDb = mutableListOf<Tracking>()

    override fun getTracking(): List<Tracking> = feedbackDb

    override fun addTracking(feedback: Tracking) {
        feedbackDb.add(feedback)
    }

}