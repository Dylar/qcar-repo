package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.buildCategoryInfo
import de.bitb.main_service.builder.buildEmptyCategoryInfo
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.CategoryInfoException
import de.bitb.main_service.models.*
import de.bitb.main_service.service.CategoryInfoService
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
internal class CategoryInfoControllerTest @Autowired constructor(
    private val mapper: ObjectMapper,
    private val mockMvc: MockMvc,
    @MockkBean(relaxed = true) private val service: CategoryInfoService
) {

    @Nested
    @DisplayName("GET category info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETCategoryInfo {

        @Test
        fun `get no category info`() {
            val info = buildCategoryInfo()

            every { service.getCategoryInfo(any()) }
                .answers {
                    val args = it.invocation.args
                    throw CategoryInfoException.UnknownCategoryException(
                        args.first() as String,
                    )
                }

            mockMvc.get("$CATEGORY_INFO_URL_V1/${info.name}")
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getCategoryInfo(info.name) }
        }

        @Test
        fun `get category info`() {
            val info = buildCategoryInfo()

            every { service.getCategoryInfo(info.name) }
                .answers { info }

            mockMvc.get("$CATEGORY_INFO_URL_V1/${info.name}")
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) { service.getCategoryInfo(info.name) }
        }
    }

    @Nested
    @DisplayName("POST category info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTCarInfo {
        @Test
        fun `add category info`() {
            //given
            val info = buildCategoryInfo()

            //when
            mockMvc
                .post(CATEGORY_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isCreated() } }

            verify(exactly = 1) { service.addCategoryInfo(info) }
        }

        @Test
        fun `try adding empty category info - throw exception`() {
            //given
            val info = buildEmptyCategoryInfo()

            every { service.addCategoryInfo(any()) }
                .answers { validateCategoryInfo(args.first() as CategoryInfo) }

            //when
            val result = mockMvc
                .post(CATEGORY_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addCategoryInfo(info) }
            assertThat(result).isEqualTo(CategoryInfoException.EmptyNameException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post(CATEGORY_INFO_URL_V1) {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addCategoryInfo(any()) }
        }
    }



//        @Test
//        fun `send empty category info return BAD REQUEST because category info has no infos`() {
//
//            fun postBadCategory(info: CategoryInfo): String {
//                return mockMvc
//                        .post(CATEGORY_INFO_URL_V1) {
//                            contentType = MediaType.APPLICATION_JSON
//                            content = mapper.writeValueAsString(info)
//                        }.andDo { print() }
//                        .andExpect { status { isBadRequest() } }
//                        .andReturn().response.contentAsString
//            }
//
//            //given
//            var emptyCategoryInfo = buildEmptyCategoryInfo()
//            //when
//            var response = postBadCategory(emptyCategoryInfo)
//            //then
//            assertThat(response).isEqualTo(CategoryInfoException.EmptyNameException().message)
//
//            //given
//            emptyCategoryInfo = emptyCategoryInfo.copy(name = "NO Sicherheit")
//            //when
//            response = postBadCategory(emptyCategoryInfo)
//            //then
//            assertThat(response).isEqualTo(CategoryInfoException.EmptyDescriptionException().message)
//
//            //given
//            emptyCategoryInfo = emptyCategoryInfo.copy(description = "Hier gehts um KEINE Sicherheit")
//            //when
//            response = postBadCategory(emptyCategoryInfo)
//            //then
//            assertThat(response).isEqualTo(CategoryInfoException.EmptyImagePathException().message)
//
//            //given
//            emptyCategoryInfo = emptyCategoryInfo.copy(imagePath = "path/to/file")
//            //when
//            mockMvc
//                    .post(CATEGORY_INFO_URL_V1) {
//                        contentType = MediaType.APPLICATION_JSON
//                        content = mapper.writeValueAsString(emptyCategoryInfo)
//                    }.andDo { print() }
//                    .andExpect { status { isCreated() } }
//        }

}