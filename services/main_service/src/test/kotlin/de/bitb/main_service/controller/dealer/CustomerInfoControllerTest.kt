package de.bitb.main_service.controller.dealer

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.controller.DEALER_URL_V1
import de.bitb.main_service.exceptions.CustomerInfoException
import de.bitb.main_service.exceptions.validateCustomerInfo
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

private fun getCustomerURL(dealer: String): String =
    "$DEALER_URL_V1/customers/$dealer"

@SpringBootTest
@AutoConfigureMockMvc
internal class CustomerInfoControllerTest @Autowired constructor(
    val mockMvc: MockMvc,
    val mapper: ObjectMapper,
    @MockkBean(relaxed = true) private val service: DealerInfoService
) {

    @Nested
    @DisplayName("GET customer info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETCustomerInfo {

        @Test
        fun `get no customer info`() {
            val info = buildCustomerInfo()

            every { service.getCustomerInfos(any()) }
                .answers {
                    val args = it.invocation.args
                    throw CustomerInfoException.UnknownDealerException(
                        args.first() as String,
                    )
                }

            mockMvc.get(getCustomerURL(info.dealer))
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getCustomerInfos(info.dealer) }
        }

        @Test
        fun `get customer infos`() {
            val info = buildCustomerInfo()
            val infos = listOf(info)

            every { service.getCustomerInfos(info.dealer) }
                .answers { infos }

            mockMvc.get(getCustomerURL(info.dealer))
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(infos))
                    }
                }

            verify(exactly = 1) { service.getCustomerInfos(info.dealer) }
        }
    }

    @Nested
    @DisplayName("POST customer info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTCustomerInfo {
        @Test
        fun `add customer info`() {
            //given
            val info = buildCustomerInfo()

            //when
            mockMvc
                .post("$DEALER_URL_V1/customer") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addCustomerInfo(info) }
        }

        @Test
        fun `try adding empty customer info - throw exception`() {
            //given
            val info = buildEmptyCustomerInfo()

            every { service.addCustomerInfo(any()) }
                .answers { validateCustomerInfo(args.first() as CustomerInfo) }

            //when
            val result = mockMvc
                .post("$DEALER_URL_V1/customer") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addCustomerInfo(info) }
            assertThat(result).isEqualTo(CustomerInfoException.EmptyDealerException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post("$DEALER_URL_V1/customer") {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addCustomerInfo(any()) }
        }
    }

}