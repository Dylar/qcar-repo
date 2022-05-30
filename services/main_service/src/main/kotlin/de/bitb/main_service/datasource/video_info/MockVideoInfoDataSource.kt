package de.bitb.main_service.datasource.video_info

import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository("video_info_database_mock")
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