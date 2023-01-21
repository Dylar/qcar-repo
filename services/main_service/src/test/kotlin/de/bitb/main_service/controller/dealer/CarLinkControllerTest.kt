package de.bitb.main_service.controller.dealer

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.*
import de.bitb.main_service.controller.DEALER_URL_V1
import de.bitb.main_service.exceptions.CarLinkException
import de.bitb.main_service.exceptions.validateCarLink
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
internal class CarLinkControllerTest @Autowired constructor(
    val mockMvc: MockMvc,
    val mapper: ObjectMapper,
    @MockkBean(relaxed = true) private val service: DealerInfoService
) {

    @Nested
    @DisplayName("GET dealer cars")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETCarLink {

        @Test
        fun `get no car links`() {
            val info = buildCarLink()

            every { service.getCarInfos(any()) }
                .answers {
                    val args = it.invocation.args
                    throw CarLinkException.NoCarLinkException(
                        args.first() as String,
                    )
                }

            mockMvc.get("$DEALER_URL_V1/getCars/${info.dealer}")
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getCarInfos(info.dealer) }
        }

        @Test
        fun `get car links`() {
            val info = buildCarLink()
            val result = listOf(buildCarInfo())

            every { service.getCarInfos(info.dealer) }
                .answers { result }

            mockMvc.get("$DEALER_URL_V1/getCars/${info.dealer}")
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(result))
                    }
                }

            verify(exactly = 1) { service.getCarInfos(info.dealer) }
        }
    }

    @Nested
    @DisplayName("POST dealer cars")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTCarLink {
        @Test
        fun `add dealer cars`() {
            //given
            val info = buildCarLink()

            //when
            mockMvc
                .post("$DEALER_URL_V1/linkCar") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.linkCarToDealer(info) }
        }

        @Test
        fun `try adding empty car links - throw exception`() {
            //given
            val info = buildEmptyCarLink()

            every { service.linkCarToDealer(any()) }
                .answers { validateCarLink(args.first() as CarLink) }

            //when
            val result = mockMvc
                .post("$DEALER_URL_V1/linkCar") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.linkCarToDealer(info) }
            assertThat(result).isEqualTo(CarLinkException.EmptyDealerException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post("$DEALER_URL_V1/linkCar") {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.linkCarToDealer(any()) }
        }
    }

}