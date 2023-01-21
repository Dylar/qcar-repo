package de.bitb.main_service.controller.dealer

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.controller.DEALER_URL_V1
import de.bitb.main_service.exceptions.SellerInfoException
import de.bitb.main_service.exceptions.validateSellerInfo
import de.bitb.main_service.models.*
import de.bitb.main_service.service.DealerInfoService
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

private fun getSellerURL(dealer: String, seller: String): String =
    "$DEALER_URL_V1/dealer/$dealer/seller/$seller"

@SpringBootTest
@AutoConfigureMockMvc
internal class SellerInfoControllerTest @Autowired constructor(
    val mockMvc: MockMvc,
    val mapper: ObjectMapper,
    @MockkBean(relaxed = true) private val service: DealerInfoService
) {

    @Nested
    @DisplayName("GET seller info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETSellerInfo {

        @Test
        fun `get no seller info`() {
            val info = buildSellerInfo()

            every { service.getSellerInfo(any(), any()) }
                .answers {
                    val args = it.invocation.args
                    throw SellerInfoException.UnknownSellerException(
                        args.first() as String,
                        args.last() as String,
                    )
                }

            mockMvc.get(getSellerURL(info.dealer, info.name))
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getSellerInfo(info.dealer, info.name) }
        }

        @Test
        fun `get seller info`() {
            val info = buildSellerInfo()

            every { service.getSellerInfo(info.dealer, info.name) }
                .answers { info }

            mockMvc.get(getSellerURL(info.dealer, info.name))
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) { service.getSellerInfo(info.dealer, info.name) }
        }
    }

    @Nested
    @DisplayName("POST seller info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTSellerInfo {
        @Test
        fun `add seller info`() {
            //given
            val info = buildSellerInfo()

            //when
            mockMvc
                .post("$DEALER_URL_V1/addSeller") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addSellerInfo(info) }
        }

        @Test
        fun `try adding empty seller info - throw exception`() {
            //given
            val info = buildEmptySellerInfo()

            every { service.addSellerInfo(any()) }
                .answers { validateSellerInfo(args.first() as SellerInfo) }

            //when
            val result = mockMvc
                .post("$DEALER_URL_V1/addSeller") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addSellerInfo(info) }
            assertThat(result).isEqualTo(SellerInfoException.EmptyDealerException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post("$DEALER_URL_V1/addSeller") {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addSellerInfo(any()) }
        }
    }

}