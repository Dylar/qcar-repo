package de.bitb.main_service.datasource.video_info

import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository(VIDEO_REPOSITORY_MOCK)
class MockVideoInfoDataSource : VideoInfoDataSource {

    private val videoInfoDB = mutableListOf<VideoInfo>()

    override fun getVideoInfo(
        brand: String,
        model: String,
        category: String,
        name: String
    ): VideoInfo? {
        return videoInfoDB.find { it.brand == brand && it.model == model && it.category == category && it.name == name }
    }

    override fun addVideoInfo(info: VideoInfo) {
        if (videoInfoDB.contains(info)) {
            videoInfoDB.replaceAll {
                if (it == info) info
                else it
            }
        } else {
            videoInfoDB.add(info)
        }
    }

}