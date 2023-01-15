package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.exceptions.TrackingException
import de.bitb.main_service.exceptions.validateTracking
import de.bitb.main_service.models.*
import de.bitb.main_service.service.TrackingService
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
internal class TrackingControllerTest @Autowired constructor(
    val mockMvc: MockMvc,
    val mapper: ObjectMapper,
    @MockkBean(relaxed = true) private val service: TrackingService
) {

    @Nested
    @DisplayName("GET tracking")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETTracking {

        @Test
        fun `get no tracking`() {
            every { service.getTracking() }
                .answers { throw TrackingException.NoTrackingException() }

            mockMvc.get(TRACKING_URL_V1)
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getTracking() }
        }

        @Test
        fun `get tracking`() {
            val tracking = listOf(buildTracking())

            every { service.getTracking() }.answers { tracking }

            mockMvc.get(TRACKING_URL_V1)
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(tracking))
                    }
                }

            verify(exactly = 1) { service.getTracking() }
        }
    }

    @Nested
    @DisplayName("POST tracking")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTTracking {
        @Test
        fun `add tracking`() {
            //given
            val tracking = buildTracking()

            //when
            mockMvc
                .post(TRACKING_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(tracking)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addTracking(tracking) }
        }

        @Test
        fun `try adding empty tracking - throw exception`() {
            //given
            val tracking = buildEmptyTracking()

            every { service.addTracking(any()) }
                .answers { validateTracking(args.first() as Tracking) }

            //when
            val result = mockMvc
                .post(TRACKING_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(tracking)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addTracking(tracking) }
            assertThat(result).isEqualTo(TrackingException.EmptyDateException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post(TRACKING_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addTracking(any()) }
        }
    }

}