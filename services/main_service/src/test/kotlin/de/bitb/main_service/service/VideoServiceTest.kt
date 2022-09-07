package de.bitb.main_service.service

import de.bitb.main_service.builder.buildEmptyVideoInfo
import de.bitb.main_service.builder.buildVideoInfo
import de.bitb.main_service.datasource.video_info.VideoInfoDataSource
import de.bitb.main_service.exceptions.VideoInfoException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class VideoServiceTest {

    private lateinit var dataSource: VideoInfoDataSource
    private lateinit var service: VideoInfoService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getVideoInfo(any(), any(), any(), any()) }.returns(null)
        service = VideoInfoService(dataSource)
    }

    @Test
    fun `get video from service`() {
        //given
        val testInfo = buildVideoInfo()
        every {
            dataSource.getVideoInfo(
                testInfo.brand,
                testInfo.model,
                testInfo.category,
                testInfo.name
            )
        }.returns(testInfo)
        //when
        val info =
            service.getVideoInfo(testInfo.brand, testInfo.model, testInfo.category, testInfo.name)
        //then
        verify(exactly = 1) {
            dataSource.getVideoInfo(
                testInfo.brand,
                testInfo.model,
                testInfo.category,
                testInfo.name
            )
        }
        assertThat(info == testInfo)
    }

    @Test
    fun `get no video from datasource - throw UnknownVideoException`() {
        //given
        val testInfo = buildVideoInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows {
                service.getVideoInfo(
                    testInfo.brand,
                    testInfo.model,
                    testInfo.category,
                    testInfo.name
                )
            }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is VideoInfoException.UnknownVideoException)
    }

    @Test
    fun `add video to service`() {
        //given
        val testInfo = buildVideoInfo()
        //when
        service.addVideoInfo(testInfo)
        //then
        verify(exactly = 1) { dataSource.addVideoInfo(testInfo) }
    }


    @Test
    fun `try adding invalid video - throw exceptions`() {
        var emptyInfo = buildEmptyVideoInfo()
        var exception: Exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyBrandException)

        emptyInfo = emptyInfo.copy(brand = "Toyota")
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyModelException)

        emptyInfo = emptyInfo.copy(model = "Corolla")
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyDescriptionException)

        emptyInfo = emptyInfo.copy(category = "Sicherheit")
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyNameException)

        emptyInfo = emptyInfo.copy(name = "Gurt")
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyDescriptionException)

        emptyInfo = emptyInfo.copy(description = "Hier lernst du wie man einen Gurt anlegt")
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyImagePathException)

        emptyInfo = emptyInfo.copy(imagePath = "path/to/file")
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyFilePathException)

        emptyInfo = emptyInfo.copy(filePath = "path/to/file")
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyTagsException)

        emptyInfo = emptyInfo.copy(tags = listOf())
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyTagsException)

        emptyInfo = emptyInfo.copy(tags = listOf("", "", ""))
        exception = assertThrows { service.addVideoInfo(emptyInfo) }
        assertThat(exception is VideoInfoException.EmptyTagsException)

        emptyInfo = emptyInfo.copy(tags = listOf("Gurt", "for", "Dummies"))
        service.addVideoInfo(emptyInfo)
        verify(exactly = 1) { dataSource.addVideoInfo(emptyInfo) }
    }

}