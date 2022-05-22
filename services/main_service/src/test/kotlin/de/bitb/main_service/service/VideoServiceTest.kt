package de.bitb.main_service.service

import de.bitb.main_service.builder.buildVideoInfo
import de.bitb.main_service.datasource.video_info.VideoInfoDataSource
import de.bitb.main_service.exceptions.VideoInfoException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.hamcrest.MatcherAssert.assertThat
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class VideoServiceTest {

    private lateinit var dataSource: VideoInfoDataSource
    private lateinit var service: VideoInfoService

    @BeforeEach
    fun setUp(){
        dataSource = mockk(relaxed = true)
        every { dataSource.getVideoInfo(any()) }.returns(null)
        service = VideoInfoService(dataSource)
    }

    @Test
    fun `get video from service`() {
        //given
        val testInfo = buildVideoInfo()
        every { dataSource.getVideoInfo(testInfo.name) }.returns(testInfo)
        //when
        val info = service.getVideoInfo(testInfo.name)
        //then
        verify(exactly = 1) { dataSource.getVideoInfo(testInfo.name) }
        assertThat("Video info not equal", info == testInfo)
    }

    @Test
    fun `get no video from datasource - throw UnknownVideoException`() {
        //given
        val testInfo = buildVideoInfo()
        //when
        val exceptionNoInfo: Exception = assertThrows { service.getVideoInfo(testInfo.name) }
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

}