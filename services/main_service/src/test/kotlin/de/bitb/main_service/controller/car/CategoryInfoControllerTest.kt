package de.bitb.main_service.controller.car

import com.fasterxml.jackson.databind.ObjectMapper
import com.ninjasquad.springmockk.MockkBean
import de.bitb.main_service.builder.buildCategoryInfo
import de.bitb.main_service.builder.buildEmptyCategoryInfo
import de.bitb.main_service.builder.buildVideoInfo
import de.bitb.main_service.controller.CAR_URL_V1
import de.bitb.main_service.exceptions.CategoryInfoException
import de.bitb.main_service.exceptions.validateCategoryInfo
import de.bitb.main_service.models.*
import de.bitb.main_service.service.CarInfoService
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

private fun getCategoryURL(brand: String, model: String, name: String): String =
    "$CAR_URL_V1/brand/$brand/model/$model/category/$name"

@SpringBootTest
@AutoConfigureMockMvc
internal class CategoryInfoControllerTest @Autowired constructor(
    private val mapper: ObjectMapper,
    private val mockMvc: MockMvc,
    @MockkBean(relaxed = true) private val service: CarInfoService
) {

    @Nested
    @DisplayName("GET category info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class GETCategoryInfo {

        @Test
        fun `get no category info`() {
            val info = buildCategoryInfo()

            every { service.getCategoryInfo(any(), any(), any()) }
                .answers {
                    val args = it.invocation.args
                    throw CategoryInfoException.UnknownCategoryException(
                        args.first() as String,
                    )
                }

            mockMvc.get(getCategoryURL(info.brand, info.model, info.name))
                .andDo { print() }
                .andExpect { status { isNotFound() } }

            verify(exactly = 1) { service.getCategoryInfo(info.brand, info.model, info.name) }
        }

        @Test
        fun `get category info`() {
            val info = buildCategoryInfo()

            every { service.getCategoryInfo(info.brand, info.model, info.name) }
                .answers { info }

            mockMvc.get(getCategoryURL(info.brand, info.model, info.name))
                .andDo { print() }
                .andExpect {
                    status { isOk() }
                    content {
                        contentType(MediaType.APPLICATION_JSON)
                        json(mapper.writeValueAsString(info))
                    }
                }

            verify(exactly = 1) { service.getCategoryInfo(info.brand, info.model, info.name) }
        }
    }

    @Nested
    @DisplayName("POST category info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class POSTCategoryInfo {
        @Test
        fun `add category info`() {
            //given
            val info = buildCategoryInfo()

            //when
            mockMvc
                .post("$CAR_URL_V1/addCategory") {
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
                .post("$CAR_URL_V1/addCategory") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(info)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }
                .andReturn().response.contentAsString

            verify(exactly = 1) { service.addCategoryInfo(info) }
            assertThat(result).isEqualTo(CategoryInfoException.EmptyBrandException().message)
        }

        @Test
        fun `send no data - throw exception`() {
            //when
            mockMvc
                .post("$CAR_URL_V1/addCategory") {
                    contentType = MediaType.APPLICATION_JSON
                    content = ""
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addCategoryInfo(any()) }
        }

        @Test
        fun `send video data - throw exception`() {
            val video = buildVideoInfo()

            every { service.addCategoryInfo(any()) }
                .answers { validateCategoryInfo(args.first() as CategoryInfo) }

            //when
            mockMvc
                .post("$CAR_URL_V1/addCategory") {
                    contentType = MediaType.APPLICATION_JSON
                    content = mapper.writeValueAsString(video)
                }
                .andDo { print() }
                .andExpect { status { isBadRequest() } }

            verify(exactly = 0) { service.addCategoryInfo(any()) }
        }
    }

}