package de.bitb.main_service.service

import de.bitb.main_service.datasource.video_info.VideoInfoDataSource
import de.bitb.main_service.exceptions.VideoInfoException
import de.bitb.main_service.models.VideoInfo
import de.bitb.main_service.models.validateVideoInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class VideoInfoService(
    @Qualifier("video_info_database_mock") @Autowired val videoDS: VideoInfoDataSource,
) {

    private val log: Logger = LoggerFactory.getLogger(VideoInfoService::class.java)

    @Throws(VideoInfoException.UnknownVideoException::class)
    fun getVideoInfo(brand: String, model: String, name: String): VideoInfo =
        videoDS.getVideoInfo(brand, model, name)
            ?: throw VideoInfoException.UnknownVideoException(brand, model, name)

    @Throws(VideoInfoException::class)
    fun addVideoInfo(info: VideoInfo) {
        validateVideoInfo(info)
        videoDS.addVideoInfo(info)
    }
}