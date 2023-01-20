package de.bitb.main_service.service

import de.bitb.main_service.builder.buildEmptyFeedback
import de.bitb.main_service.builder.buildFeedback
import de.bitb.main_service.datasource.FeedbackDataSource
import de.bitb.main_service.exceptions.FeedbackException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class FeedbackServiceTest {

    private lateinit var dataSource: FeedbackDataSource
    private lateinit var service: FeedbackService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getFeedback(any()) }.returns(listOf())
        service = FeedbackService(dataSource)
    }

    @Test
    fun `get feedback from service`() {
        //given
        val customer = "Customer"
        val testFeedback = buildFeedback()
        every { dataSource.getFeedback(customer) }.returns(listOf(testFeedback))
        //when
        val feedback = service.getFeedback(customer)
        //then
        verify(exactly = 1) { dataSource.getFeedback(customer) }
        assertThat(feedback.first() == testFeedback)
    }

    @Test
    fun `get no feedback from datasource - throw NoFeedbackException`() {
        //when
        val exceptionNoFeedback: Exception = assertThrows { service.getFeedback("customer") }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoFeedback is FeedbackException.NoFeedbackException)
    }

    @Test
    fun `try adding invalid feedback - throw exceptions`() {
        var emptyFeedback = buildEmptyFeedback()
        var exception: Exception = assertThrows { service.addFeedback(emptyFeedback) }
        assertThat(exception is FeedbackException.EmptyDateException)

        emptyFeedback = emptyFeedback.copy(date = "WRONG DATE")
        exception = assertThrows { service.addFeedback(emptyFeedback) }
        assertThat(exception is FeedbackException.WrongDateFormatException)

        emptyFeedback = emptyFeedback.copy(date = "2022-08-04T21:55:54.940")
        exception = assertThrows { service.addFeedback(emptyFeedback) }
        assertThat(exception is FeedbackException.EmptyTextException)

        emptyFeedback = emptyFeedback.copy(text = "Dolle App")
        service.addFeedback(emptyFeedback)
        verify(exactly = 1) { dataSource.addFeedback(any()) }
    }

}