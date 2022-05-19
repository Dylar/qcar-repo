package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import de.bitb.main_service.builder.buildCategoryInfo
import de.bitb.main_service.builder.buildEmptyCategoryInfo
import de.bitb.main_service.exceptions.CategoryInfoException
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
internal class CategoryInfoControllerTest @Autowired constructor(
        val mockMvc: MockMvc,
        val mapper: ObjectMapper,
) {

    @Nested
    @DisplayName("POST category info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class AddCategoryInfo {

        @Test
        fun `add category info`() {

            //given
            val newInfo = buildCategoryInfo()

            mockMvc.get("$CATEGORY_INFO_URL_V1/${newInfo.name}")
                    .andDo { print() }
                    .andExpect { status { isNotFound() } }

            //when
            mockMvc
                    .post(CATEGORY_INFO_URL_V1) {
                        contentType = MediaType.APPLICATION_JSON
                        content = mapper.writeValueAsString(newInfo)
                    }
                    .andDo { print() }
                    .andExpect { status { isCreated() } }

            //then
            mockMvc.get("$CATEGORY_INFO_URL_V1/${newInfo.name}")
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
        fun `send empty category info return BAD REQUEST because category info has no infos`() {

            fun postBadCategory(info: CategoryInfo): String {
                return mockMvc
                        .post(CATEGORY_INFO_URL_V1) {
                            contentType = MediaType.APPLICATION_JSON
                            content = mapper.writeValueAsString(info)
                        }.andDo { print() }
                        .andExpect { status { isBadRequest() } }
                        .andReturn().response.contentAsString
            }

            //given
            var emptyCategoryInfo = buildEmptyCategoryInfo()
            //when
            var response = postBadCategory(emptyCategoryInfo)
            //then
            assertThat(response).isEqualTo(CategoryInfoException.EmptyNameException().message)

            //given
            emptyCategoryInfo = emptyCategoryInfo.copy(name = "NO Sicherheit")
            //when
            response = postBadCategory(emptyCategoryInfo)
            //then
            assertThat(response).isEqualTo(CategoryInfoException.EmptyDescriptionException().message)

            //given
            emptyCategoryInfo = emptyCategoryInfo.copy(description = "Hier gehts um KEINE Sicherheit")
            //when
            response = postBadCategory(emptyCategoryInfo)
            //then
            assertThat(response).isEqualTo(CategoryInfoException.EmptyImagePathException().message)

            //given
            emptyCategoryInfo = emptyCategoryInfo.copy(imagePath = "path/to/file")
            //when
            mockMvc
                    .post(CATEGORY_INFO_URL_V1) {
                        contentType = MediaType.APPLICATION_JSON
                        content = mapper.writeValueAsString(emptyCategoryInfo)
                    }.andDo { print() }
                    .andExpect { status { isCreated() } }
        }

    }

}