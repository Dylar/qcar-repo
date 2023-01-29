package de.bitb.main_service.controller.dealer

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.controller.DEALER_URL_V1
import de.bitb.main_service.exceptions.SaleInfoException
import de.bitb.main_service.exceptions.validateSaleInfo
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

@SpringBootTest
@AutoConfigureMockMvc
internal class SaleInfoControllerTest @Autowired constructor(
    val mockMvc: MockMvc,
    val mapper: ObjectMapper,
    @MockkBean(relaxed = true) private val service: DealerInfoService
) {

    @Nested
    @DisplayName("GET sale info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETSaleInfo {

        @Test
        fun `get no sale info`() {
            val info = buildSaleInfo(TEST_SALE_INFO)

            every { service.getSaleInfo(any()) }
                .answers {
                    val args = it.invocation.args
                    throw SaleInfoException.UnknownKeyException(
                        args.first() as String,
                    )
                }

            mockMvc.get("$DEALER_URL_V1/key/${info.key}")
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getSaleInfo(info.key) }
        }

        @Test
        fun `get sale info`() {
            val info = buildSaleInfo(TEST_SALE_INFO)

            every { service.getSaleInfo(info.key) }
                .answers { info }

            mockMvc.get("$DEALER_URL_V1/key/${info.key}")
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) { service.getSaleInfo(info.key) }
        }
    }

    @Nested
    @DisplayName("POST sale info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTSaleInfo {
        @Test
        fun `add sale info`() {
            //given
            val info = buildSaleInfo()

            //when
            mockMvc
                .post("$DEALER_URL_V1/addSale") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addSaleInfo(info) }
        }

        @Test
        fun `try adding empty sale info - throw exception`() {
            //given
            val info = buildInvalidSaleInfo()

            every { service.addSaleInfo(any()) }
                .answers { validateSaleInfo(args.first() as SaleInfo) }

            //when
            val result = mockMvc
                .post("$DEALER_URL_V1/addSale") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addSaleInfo(info) }
            assertThat(result).isEqualTo(SaleInfoException.EmptyBrandException().message)
        }

        @Test
        fun `try adding sale info with key - throw exception`() {
            //given
            val info = buildSaleInfo(TEST_SALE_INFO)

            every { service.addSaleInfo(any()) }
                .answers { validateSaleInfo(args.first() as SaleInfo) }

            //when
            val result = mockMvc
                .post("$DEALER_URL_V1/addSale") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addSaleInfo(info) }
            assertThat(result).isEqualTo(SaleInfoException.NotEmptyKeyException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post("$DEALER_URL_V1/addSale") {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addSaleInfo(any()) }
        }
    }

}