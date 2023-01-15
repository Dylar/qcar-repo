package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.exceptions.FeedbackException
import de.bitb.main_service.exceptions.validateFeedback
import de.bitb.main_service.models.*
import de.bitb.main_service.service.FeedbackService
import io.mockk.every
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.*
import org.junit.jupiter.api.TestInstance.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get
import org.springframework.test.web.servlet.post

@SpringBootTest
@AutoConfigureMockMvc
internal class FeedbackControllerTest @Autowired constructor(
    val mockMvc: MockMvc,
    val mapper: ObjectMapper,
    @MockkBean(relaxed = true) private val service: FeedbackService
) {

    @Nested
    @DisplayName("GET feedback")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETFeedback {

        @Test
        fun `get no feedback`() {
            every { service.getFeedback() }
                .answers { throw FeedbackException.NoFeedbackException() }

            mockMvc.get(FEEDBACK_URL_V1)
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getFeedback() }
        }

        @Test
        fun `get feedback`() {
            val feedback = listOf(buildFeedback())

            every { service.getFeedback() }.answers { feedback }

            mockMvc.get(FEEDBACK_URL_V1)
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(feedback))
                    }
                }

            verify(exactly = 1) { service.getFeedback() }
        }
    }

    @Nested
    @DisplayName("POST feedback")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTFeedback {
        @Test
        fun `add feedback`() {
            //given
            val feedback = buildFeedback()

            //when
            mockMvc
                .post(FEEDBACK_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(feedback)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addFeedback(feedback) }
        }

        @Test
        fun `try adding empty feedback - throw exception`() {
            //given
            val feedback = buildEmptyFeedback()

            every { service.addFeedback(any()) }
                .answers { validateFeedback(args.first() as Feedback) }

            //when
            val result = mockMvc
                .post(FEEDBACK_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(feedback)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addFeedback(feedback) }
            assertThat(result).isEqualTo(FeedbackException.EmptyDateException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post(FEEDBACK_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addFeedback(any()) }
        }
    }

}