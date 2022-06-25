package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.models.*
import de.bitb.main_service.service.SellInfoService
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
internal class SellInfoControllerTest @Autowired constructor(
        val mockMvc: MockMvc,
        val mapper: ObjectMapper,
        @MockkBean(relaxed = true) private val service: SellInfoService
) {

    @Nested
    @DisplayName("GET sell info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETSellInfo {

        @Test
        fun `get no sell info`() {
            val info = buildSellInfo()

            every { service.getSellInfo(any()) }
                .answers {
                    val args = it.invocation.args
                    throw SellInfoException.UnknownKeyException(
                        args.first() as String,
                    )
                }

            mockMvc.get("$SELL_INFO_URL_V1/${info.key}")
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getSellInfo(info.key) }
        }

        @Test
        fun `get sell info`() {
            val info = buildSellInfo()

            every { service.getSellInfo(info.key) }
                .answers { info }

            mockMvc.get("$SELL_INFO_URL_V1/${info.key}")
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) { service.getSellInfo(info.key) }
        }
    }

    @Nested
    @DisplayName("POST sell info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTSellInfo {
        @Test
        fun `add sell info`() {
            //given
            val info = buildSellInfo()

            //when
            mockMvc
                .post(SELL_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addSellInfo(info) }
        }

        @Test
        fun `try adding empty sell info - throw exception`() {
            //given
            val info = buildInvalidSellInfo()

            every { service.addSellInfo(any()) }
                .answers { validateSellInfo(args.first() as SellInfo) }

            //when
            val result = mockMvc
                .post(SELL_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addSellInfo(info) }
            assertThat(result).isEqualTo(SellInfoException.EmptyBrandException().message)
        }

        @Test
        fun `try adding sell info with key - throw exception`() {
            //given
            val info = buildSellInfo()

            every { service.addSellInfo(any()) }
                .answers { validateSellInfo(args.first() as SellInfo) }

            //when
            val result = mockMvc
                .post(SELL_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addSellInfo(info) }
            assertThat(result).isEqualTo(SellInfoException.NotEmptyKeyException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post(SELL_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addSellInfo(any()) }
        }
    }

}