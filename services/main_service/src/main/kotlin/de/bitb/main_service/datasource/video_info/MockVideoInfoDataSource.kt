package de.bitb.main_service.datasource.video_info

import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository(VIDEO_REPOSITORY_MOCK)
class MockVideoInfoDataSource : VideoInfoDataSource {

    private val videoInfoDB = mutableListOf<VideoInfo>()

    override fun getVideoInfo(brand: String, model: String, name: String): VideoInfo? {
        return videoInfoDB.find { it.brand == brand && it.model == model && it.name == name }
    }

    override fun addVideoInfo(info: VideoInfo) {
        if (videoInfoDB.contains(info)) {
            videoInfoDB.replaceAll {
                if (it.name == info.name) info
                else it
            }
        } else {
            videoInfoDB.add(info)
        }
    }

}