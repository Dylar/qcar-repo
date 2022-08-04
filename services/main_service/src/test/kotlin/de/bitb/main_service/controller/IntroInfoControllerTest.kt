package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.exceptions.IntroInfoException
import de.bitb.main_service.models.*
import de.bitb.main_service.service.IntroInfoService
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
internal class IntroInfoControllerTest @Autowired constructor(
    val mockMvc: MockMvc,
    val mapper: ObjectMapper,
    @MockkBean(relaxed = true) private val service: IntroInfoService
) {

    @Nested
    @DisplayName("GET intro info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETIntroInfo {

        @Test
        fun `get no intro info`() {
            val info = buildIntroInfo()

            every { service.getIntroInfo(any(), any(), any(), any()) }
                .answers {
                    val args = it.invocation.args
                    throw IntroInfoException.UnknownIntroException(
                        args[0] as String,
                        args[1] as String,
                        args[2] as String,
                        args[3] as String,
                    )
                }

            mockMvc.get("$INTRO_INFO_URL_V1/${info.dealer}/${info.seller}/${info.brand}/${info.model}")
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) {
                service.getIntroInfo(
                    info.dealer,
                    info.seller,
                    info.brand,
                    info.model
                )
            }
        }

        @Test
        fun `get intro info`() {
            val info = buildIntroInfo()

            every { service.getIntroInfo(info.dealer, info.seller, info.brand, info.model) }
                .answers { info }

            mockMvc.get("$INTRO_INFO_URL_V1/${info.dealer}/${info.seller}/${info.brand}/${info.model}")
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) {
                service.getIntroInfo(
                    info.dealer,
                    info.seller,
                    info.brand,
                    info.model
                )
            }
        }
    }

    @Nested
    @DisplayName("POST intro info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTIntroInfo {
        @Test
        fun `add intro info`() {
            //given
            val info = buildIntroInfo()

            //when
            mockMvc
                .post(INTRO_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addIntroInfo(info) }
        }

        @Test
        fun `try adding empty intro info - throw exception`() {
            //given
            val info = buildEmptyIntroInfo()

            every { service.addIntroInfo(any()) }
                .answers { validateIntroInfo(args.first() as IntroInfo) }

            //when
            val result = mockMvc
                .post(INTRO_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addIntroInfo(info) }
            assertThat(result).isEqualTo(IntroInfoException.EmptyDealerException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post(INTRO_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addIntroInfo(any()) }
        }
    }

}