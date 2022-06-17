package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.buildVideoInfo
import de.bitb.main_service.builder.buildEmptyVideoInfo
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.VideoInfoException
import de.bitb.main_service.models.*
import de.bitb.main_service.service.VideoInfoService
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
internal class VideoInfoControllerTest @Autowired constructor(
    private val mapper: ObjectMapper,
    private val mockMvc: MockMvc,
    @MockkBean(relaxed = true) private val service: VideoInfoService
) {

    @Nested
    @DisplayName("GET video info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETVideoInfo {

        @Test
        fun `get no video info`() {
            val info = buildVideoInfo()

            every { service.getVideoInfo(any(), any(), any(), any()) }
                .answers {
                    val args = it.invocation.args
                    throw VideoInfoException.UnknownVideoException(
                        args[0] as String,
                        args[1] as String,
                        args[2] as String
                    )
                }

            mockMvc.get("$VIDEO_INFO_URL_V1/${info.brand}/${info.model}/${info.category}/${info.name}")
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) {
                service.getVideoInfo(
                    info.brand,
                    info.model,
                    info.category,
                    info.name
                )
            }
        }

        @Test
        fun `get video info`() {
            val info = buildVideoInfo()

            every { service.getVideoInfo(info.brand, info.model, info.category, info.name) }
                .answers { info }

            mockMvc.get("$VIDEO_INFO_URL_V1/${info.brand}/${info.model}/${info.category}/${info.name}")
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) {
                service.getVideoInfo(
                    info.brand,
                    info.model,
                    info.category,
                    info.name
                )
            }
        }
    }

    @Nested
    @DisplayName("POST video info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTVideoInfo {
        @Test
        fun `add video info`() {
            //given
            val info = buildVideoInfo()

            //when
            mockMvc
                .post(VIDEO_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addVideoInfo(info) }
        }

        @Test
        fun `try adding empty video info - throw exception`() {
            //given
            val info = buildEmptyVideoInfo()

            every { service.addVideoInfo(any()) }
                .answers { validateVideoInfo(args.first() as VideoInfo) }

            //when
            val result = mockMvc
                .post(VIDEO_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addVideoInfo(info) }
            assertThat(result).isEqualTo(CarInfoException.EmptyBrandException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post(VIDEO_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addVideoInfo(any()) }
        }
    }

}