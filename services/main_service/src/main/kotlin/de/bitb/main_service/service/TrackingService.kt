package de.bitb.main_service.service

import de.bitb.main_service.datasource.tracking.*
import de.bitb.main_service.exceptions.TrackingException
import de.bitb.main_service.models.Tracking
import de.bitb.main_service.exceptions.validateTracking
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class TrackingService(
    @Qualifier(TRACKING_REPOSITORY_IN_USE) @Autowired val trackingDS: TrackingDataSource
) {
    private val log: Logger = LoggerFactory.getLogger(TrackingService::class.java)

    @Throws(TrackingException::class)
    fun addTracking(tracking: Tracking) {
        validateTracking(tracking)
        trackingDS.addTracking(tracking)
    }

    @Throws(TrackingException.NoTrackingException::class)
    fun getTracking(customer: String): List<Tracking> =
        trackingDS.getTracking(customer).ifEmpty { throw TrackingException.NoTrackingException() }

}