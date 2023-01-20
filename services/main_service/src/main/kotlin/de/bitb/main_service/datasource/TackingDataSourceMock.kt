package de.bitb.main_service.datasource

import de.bitb.main_service.datasource.tracking.TRACKING_REPOSITORY_MOCK
import de.bitb.main_service.datasource.tracking.TrackingDataSource
import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(TRACKING_REPOSITORY_MOCK)
class MockTrackingDataSource : TrackingDataSource {

    private val log: Logger = LoggerFactory.getLogger(MockTrackingDataSource::class.java)

    private val feedbackDb = mutableListOf<Tracking>()

    override fun getTracking(customer:String): List<Tracking> = feedbackDb

    override fun addTracking(tracking: Tracking) {
        feedbackDb.add(tracking)
    }

}