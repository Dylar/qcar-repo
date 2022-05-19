package de.bitb.main_service.datasource.video_info

import de.bitb.main_service.models.VideoInfo
import org.springframework.stereotype.Repository

interface VideoInfoDataSource {
    fun getVideoInfo(name:String) : VideoInfo?

    fun addVideoInfo(info: VideoInfo)
}

@Repository("video_info_database")
class DBVideoInfoInfoDataSource : VideoInfoDataSource {
    override fun getVideoInfo(name: String): VideoInfo? {
        TODO("Not yet implemented")
    }

    override fun addVideoInfo(info: VideoInfo) {
        TODO("Not yet implemented")
    }
}