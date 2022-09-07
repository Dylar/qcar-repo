package de.bitb.main_service.service

import de.bitb.main_service.builder.buildEmptyTracking
import de.bitb.main_service.builder.buildTracking
import de.bitb.main_service.datasource.tracking.TrackingDataSource
import de.bitb.main_service.exceptions.TrackingException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class TrackingServiceTest {

    private lateinit var dataSource: TrackingDataSource
    private lateinit var service: TrackingService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getTracking() }.returns(listOf())
        service = TrackingService(dataSource)
    }

    @Test
    fun `get tracking from service`() {
        //given
        val testTracking = buildTracking()
        every { dataSource.getTracking() }.returns(listOf(testTracking))
        //when
        val Tracking = service.getTracking()
        //then
        verify(exactly = 1) { dataSource.getTracking() }
        assertThat(Tracking.first() == testTracking)
    }

    @Test
    fun `get no tracking from datasource - throw UnknownSellerException`() {
        //when
        val exceptionNoTracking: Exception = assertThrows { service.getTracking() }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoTracking is TrackingException.NoTrackingException)
    }

    @Test
    fun `try adding invalid tracking - throw exceptions`() {
        var emptyTracking = buildEmptyTracking()
        var exception: Exception = assertThrows { service.addTracking(emptyTracking) }
        assertThat(exception is TrackingException.EmptyDateException)

        emptyTracking = emptyTracking.copy(date = "WRONG DATE")
        exception = assertThrows { service.addTracking(emptyTracking) }
        assertThat(exception is TrackingException.WrongDateFormatException)

        emptyTracking = emptyTracking.copy(date = "2022-08-04T21:55:54.940")
        exception = assertThrows { service.addTracking(emptyTracking) }
        assertThat(exception is TrackingException.EmptyTextException)

        emptyTracking = emptyTracking.copy(text = "Dolle App")
        service.addTracking(emptyTracking)
        verify(exactly = 1) { dataSource.addTracking(any()) }
    }

}