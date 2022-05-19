package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import de.bitb.main_service.builder.buildEmptySellInfo
import de.bitb.main_service.builder.buildEmptyVideoInfo
import de.bitb.main_service.builder.buildSellInfo
import de.bitb.main_service.exceptions.SellInfoException
import de.bitb.main_service.exceptions.VideoInfoException
import de.bitb.main_service.models.*
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.*
import org.junit.jupiter.api.TestInstance.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.post

@SpringBootTest
@AutoConfigureMockMvc
internal class SellInfoControllerTest @Autowired constructor(
        val mockMvc: MockMvc,
        val mapper: ObjectMapper,
) {

    @Nested
    @DisplayName("POST sell info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class AddSellInfo {

        @Test
        fun `add sell info`() {
            //given
            val newInfo = buildSellInfo()

            //when //then
            mockMvc
                    .post(SELL_INFO_URL_V1) {
                        contentType = MediaType.APPLICATION_JSON
                        content = mapper.writeValueAsString(newInfo)
                    }
                    .andDo { print() }
                    .andExpect { status { isCreated() } }
        }

//        @Test
//        fun `set config return BAD REQUEST when value type is not valid type`() {
//
//            fun postBadSell(info: SellInfo): String {
//                return mockMvc
//                        .post(SELL_INFO_URL_V1) {
//                            contentType = MediaType.APPLICATION_JSON
//                            content = mapper.writeValueAsString(info)
//                        }.andDo { print() }
//                        .andExpect { status { isBadRequest() } }
//                        .andReturn().response.contentAsString
//            }
//
//            //given
//            var emptySellInfo = buildEmptySellInfo()
//            //when
//            var response = postBadSell(emptySellInfo)
//            //then
//            assertThat(response).isEqualTo(VideoInfoException.EmptyBrandException().message)
//
////            class UnknownKeyException(msg: String) : SellInfoException(msg)
////            class InvalidKeyException(msg: String) : SellInfoException(msg)
////            class EmptyBrandException : SellInfoException("Brand is empty")
////            class EmptyModelException : SellInfoException("Model is empty")
////            class EmptySellerException : SellInfoException("Seller is empty")
////            class EmptyCarDealerException : SellInfoException("Car dealer is empty")
////            class EmptyKeyException : SellInfoException("Key is empty")
//        }

    }

}