package de.bitb.main_service.controller.dealer

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.controller.DEALER_URL_V1
import de.bitb.main_service.exceptions.DealerInfoException
import de.bitb.main_service.exceptions.validateDealerInfo
import de.bitb.main_service.models.*
import de.bitb.main_service.service.SellerInfoService
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

private fun getDealerURL(name: String): String = "$DEALER_URL_V1/dealer/$name"

@SpringBootTest
@AutoConfigureMockMvc
internal class DealerInfoControllerTest @Autowired constructor(
    val mockMvc: MockMvc,
    val mapper: ObjectMapper,
    @MockkBean(relaxed = true) private val service: SellerInfoService
) {

    @Nested
    @DisplayName("GET dealer info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETDealerInfo {

        @Test
        fun `get no dealer info`() {
            val info = buildDealerInfo()

            every { service.getDealerInfo(any()) }
                .answers {
                    val args = it.invocation.args
                    throw DealerInfoException.UnknownDealerException(
                        args.first() as String,
                    )
                }

            mockMvc.get(getDealerURL(info.name))
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getDealerInfo(info.name) }
        }

        @Test
        fun `get dealer info`() {
            val info = buildDealerInfo()

            every { service.getDealerInfo(info.name) }
                .answers { info }

            mockMvc.get(getDealerURL(info.name))
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) { service.getDealerInfo(info.name) }
        }
    }

    @Nested
    @DisplayName("POST dealer info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTDealerInfo {
        @Test
        fun `add dealer info`() {
            //given
            val info = buildDealerInfo()

            //when
            mockMvc
                .post("$DEALER_URL_V1/addDealer") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addDealerInfo(info) }
        }

        @Test
        fun `try adding empty dealer info - throw exception`() {
            //given
            val info = buildEmptyDealerInfo()

            every { service.addDealerInfo(any()) }
                .answers { validateDealerInfo(args.first() as DealerInfo) }

            //when
            val result = mockMvc
                .post("$DEALER_URL_V1/addDealer") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addDealerInfo(info) }
            assertThat(result).isEqualTo(DealerInfoException.EmptyNameException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post("$DEALER_URL_V1/addDealer") {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addDealerInfo(any()) }
        }
    }

}