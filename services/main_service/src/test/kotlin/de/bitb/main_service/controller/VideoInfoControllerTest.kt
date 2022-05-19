package de.bitb.main_service.controller

import com.fasterxml.jackson.databind.ObjectMapper
import de.bitb.main_service.builder.buildVideoInfo
import de.bitb.main_service.builder.buildEmptyVideoInfo
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
import org.springframework.test.web.servlet.get
import org.springframework.test.web.servlet.post

@SpringBootTest
@AutoConfigureMockMvc
internal class VideoInfoControllerTest @Autowired constructor(
        val mockMvc: MockMvc,
        val mapper: ObjectMapper,
) {

    @Nested
    @DisplayName("POST video info")
    @TestInstance(Lifecycle.PER_CLASS)
    inner class AddVideoInfo {

        @Test
        fun `add video info`() {
            //given
            val newInfo = buildVideoInfo()

            mockMvc.get("$VIDEO_INFO_URL_V1/${newInfo.brand}/${newInfo.model}/${newInfo.name}")
                    .andDo { print() }
                    .andExpect { status { isNotFound() } }

            //when
            mockMvc
                    .post(VIDEO_INFO_URL_V1) {
                        contentType = MediaType.APPLICATION_JSON
                        content = mapper.writeValueAsString(newInfo)
                    }
                    .andDo { print() }
                    .andExpect { status { isCreated() } }

            //then
            mockMvc.get("$VIDEO_INFO_URL_V1/${newInfo.brand}/${newInfo.model}/${newInfo.name}")
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
        fun `send empty video info return BAD REQUEST because video info has no infos`() {

            fun postBadVideo(info: VideoInfo): String {
                return mockMvc
                        .post(VIDEO_INFO_URL_V1) {
                            contentType = MediaType.APPLICATION_JSON
                            content = mapper.writeValueAsString(info)
                        }.andDo { print() }
                        .andExpect { status { isBadRequest() } }
                        .andReturn().response.contentAsString
            }

            //given
            var emptyVideoInfo = buildEmptyVideoInfo()
            //when
            var response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyBrandException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(brand = "Toyota")
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyModelException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(model = "Corolla")
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyCategoryException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(category = "Sicherheit")
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyNameException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(name = "Gurt")
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyDescriptionException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(description = "Hier lernst du wie man einen Gurt anlegt")
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyImagePathException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(imagePath = "path/to/file")
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyFilePathException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(filePath = "path/to/file")
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyTagsException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(tags = listOf())
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyTagsException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(tags = listOf("","",""))
            //when
            response = postBadVideo(emptyVideoInfo)
            //then
            assertThat(response).isEqualTo(VideoInfoException.EmptyTagsException().message)

            //given
            emptyVideoInfo = emptyVideoInfo.copy(tags = listOf("Gurt","for","Dummies"))
            //when
            mockMvc
                    .post(VIDEO_INFO_URL_V1) {
                        contentType = MediaType.APPLICATION_JSON
                        content = mapper.writeValueAsString(emptyVideoInfo)
                    }.andDo { print() }
                    .andExpect { status { isCreated() } }
        }

    }

}