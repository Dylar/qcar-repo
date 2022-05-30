package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.builder.buildEmptyCarInfo
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.validateCarInfo
import de.bitb.main_service.service.CarInfoService
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.*
import org.junit.jupiter.api.TestInstance.*
import org.junit.jupiter.api.extension.ExtendWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.info.BuildProperties
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.context.TestConfiguration
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Import
import org.springframework.context.annotation.Primary
import org.springframework.http.MediaType
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.context.junit.jupiter.SpringExtension
import org.springframework.test.context.junit4.SpringRunner
import org.springframework.test.util.AssertionErrors.assertEquals
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get
import org.springframework.test.web.servlet.post

@SpringBootTest
@AutoConfigureMockMvc
internal class CarInfoControllerTest @Autowired constructor(
    private val mapper: ObjectMapper,
    private val mockMvc: MockMvc,
    @MockkBean(relaxed = true) private val service: CarInfoService
) {

    @Nested
    @DisplayName("GET car info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETCarInfo {

        @Test
        fun `get no car info`() {
            val info = buildCarInfo()

            every { service.getCarInfo(any(), any()) }
                .answers {
                    val args = it.invocation.args
                    throw CarInfoException.UnknownCarException(
                        args.first() as String,
                        args.last() as String
                    )
                }

            mockMvc.get("$CAR_INFO_URL_V1/${info.brand}/${info.model}")
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getCarInfo(info.brand, info.model) }
        }

        @Test
        fun `get car info`() {
            val info = buildCarInfo()

            every { service.getCarInfo(info.brand, info.model) }
                .answers { info }

            mockMvc.get("$CAR_INFO_URL_V1/${info.brand}/${info.model}")
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) { service.getCarInfo(info.brand, info.model) }
        }
    }

    @Nested
    @DisplayName("POST car info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTCarInfo {
        @Test
        fun `add car info`() {
            //given
            val info = buildCarInfo()

            //when
            mockMvc
                .post(CAR_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addCarInfo(info) }
        }

        @Test
        fun `try adding empty car info - throw exception`() {
            //given
            val info = buildEmptyCarInfo()

            every { service.addCarInfo(any()) }
                .answers { validateCarInfo(args.first() as CarInfo) }

            //when
            val result = mockMvc
                .post(CAR_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addCarInfo(info) }
            assertThat(result).isEqualTo(CarInfoException.EmptyBrandException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
             mockMvc
                .post(CAR_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addCarInfo(any()) }
        }
    }

//        @Test
//        fun `send empty car info return BAD REQUEST because car info has no infos`() {
//
//            fun postBadCar(info: CarInfo): String {
//                return mockMvc
//                        .post(CAR_INFO_URL_V1) {
//                            contentType = MediaType.APPLICATION_JSON
//                            content = mapper.writeValueAsString(info)
//                        }.andDo { print() }
//                        .andExpect { status { isBadRequest() } }
//                        .andReturn().response.contentAsString
//            }
//
//            //given
//            var emptyCarInfo = buildEmptyCarInfo()
//            //when
//            var response = postBadCar(emptyCarInfo)
//            //then
//            assertThat(response).isEqualTo(CarInfoException.EmptyBrandException().message)
//
//            //given
//            emptyCarInfo = emptyCarInfo.copy(brand = "Brand")
//            //when
//            response = postBadCar(emptyCarInfo)
//            //then
//            assertThat(response).isEqualTo(CarInfoException.EmptyModelException().message)
//
//            //given
//            emptyCarInfo = emptyCarInfo.copy(model = "model")
//            //when
//            response = postBadCar(emptyCarInfo)
//            //then
//            assertThat(response).isEqualTo(CarInfoException.EmptyImagePathException().message)
//
//            //given
//            emptyCarInfo = emptyCarInfo.copy(imagePath = "path/to/file")
//            //when
//            mockMvc
//                    .post(CAR_INFO_URL_V1) {
//                        contentType = MediaType.APPLICATION_JSON
//                        content = mapper.writeValueAsString(emptyCarInfo)
//                    }.andDo { print() }
//                    .andExpect { status { isCreated() } }
//        }

}