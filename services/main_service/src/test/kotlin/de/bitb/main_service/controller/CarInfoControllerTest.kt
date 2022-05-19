package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.builder.buildEmptyCarInfo
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.models.*
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
internal class CarInfoControllerTest @Autowired constructor(
        val mockMvc: MockMvc,
        val mapper: ObjectMapper,
) {

    @Nested
    @DisplayName("POST car info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class AddCarInfo {

        @Test
        fun `add car info`() {
            //given
            val newInfo = buildCarInfo()

            mockMvc.get("$CAR_INFO_URL_V1/${newInfo.brand}/${newInfo.model}")
                    .andDo { print() }
                    .andExpect { status { isNotFound() } }

            //when
            mockMvc
                    .post(CAR_INFO_URL_V1) {
                        contentType = MediaType.APPLICATION_JSON
                        content = mapper.writeValueAsString(newInfo)
                    }
                    .andDo { print() }
                    .andExpect {
                        status { isCreated() }
                    }

            //then
            mockMvc.get("$CAR_INFO_URL_V1/${newInfo.brand}/${newInfo.model}")
                    .andDo { print() }
                    .andExpect {
                        status { isOk() }
                        content {
                            contentType(MediaType.APPLICATION_JSON)
                            json(mapper.writeValueAsString(newInfo))
                        }
                    }
        }

        @Test
        fun `send empty car info return BAD REQUEST because car info has no infos`() {

            fun postBadCar(info: CarInfo): String {
                return mockMvc
                        .post(CAR_INFO_URL_V1) {
                            contentType = MediaType.APPLICATION_JSON
                            content = mapper.writeValueAsString(info)
                        }.andDo { print() }
                        .andExpect { status { isBadRequest() } }
                        .andReturn().response.contentAsString
            }

            //given
            var emptyCarInfo = buildEmptyCarInfo()
            //when
            var response = postBadCar(emptyCarInfo)
            //then
            assertThat(response).isEqualTo(CarInfoException.EmptyBrandException().message)

            //given
            emptyCarInfo = emptyCarInfo.copy(brand = "Brand")
            //when
            response = postBadCar(emptyCarInfo)
            //then
            assertThat(response).isEqualTo(CarInfoException.EmptyModelException().message)

            //given
            emptyCarInfo = emptyCarInfo.copy(model = "model")
            //when
            response = postBadCar(emptyCarInfo)
            //then
            assertThat(response).isEqualTo(CarInfoException.EmptyImagePathException().message)

            //given
            emptyCarInfo = emptyCarInfo.copy(imagePath = "path/to/file")
            //when
            mockMvc
                    .post(CAR_INFO_URL_V1) {
                        contentType = MediaType.APPLICATION_JSON
                        content = mapper.writeValueAsString(emptyCarInfo)
                    }.andDo { print() }
                    .andExpect { status { isCreated() } }
        }

    }

}