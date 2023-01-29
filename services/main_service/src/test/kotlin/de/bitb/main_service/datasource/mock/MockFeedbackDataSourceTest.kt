package de.bitb.main_service.datasource.mock

import de.bitb.main_service.builder.buildFeedback
import de.bitb.main_service.datasource.FeedbackDataSourceMock
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test

internal class MockFeedbackDataSourceTest {

    private val dataSource = FeedbackDataSourceMock()

    @Test
    fun `get no sale info from data source`() {
        //when
        val entries = dataSource.getFeedback("Customer")
        //then
        assertThat(entries.isEmpty())
    }

    @Test
    fun `get sale info by key from data source`() {
        //given
        val dbFeedback = buildFeedback()
        dataSource.addFeedback(dbFeedback)
        //when
        val feedback = dataSource.getFeedback("Customer")
        //then
        assertThat(feedback.first() == dbFeedback)
    }
}