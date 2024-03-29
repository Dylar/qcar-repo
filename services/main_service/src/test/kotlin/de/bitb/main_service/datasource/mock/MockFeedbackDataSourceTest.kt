package de.bitb.main_service.datasource.mock

import de.bitb.main_service.builder.buildFeedback
import de.bitb.main_service.datasource.feedback.MockFeedbackDataSource
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test

internal class MockFeedbackDataSourceTest {

    private val dataSource = MockFeedbackDataSource()

    @Test
    fun `get no sell info from data source`() {
        //when
        val entries = dataSource.getFeedback()
        //then
        assertThat(entries.isEmpty())
    }

    @Test
    fun `get sell info by key from data source`() {
        //given
        val dbFeedback = buildFeedback()
        dataSource.addFeedback(dbFeedback)
        //when
        val feedback = dataSource.getFeedback()
        //then
        assertThat(feedback.first() == dbFeedback)
    }
}