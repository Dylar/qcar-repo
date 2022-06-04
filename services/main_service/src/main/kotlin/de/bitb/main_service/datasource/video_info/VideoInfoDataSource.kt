package de.bitb.main_service.datasource.video_info

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.FirestoreApi
import de.bitb.main_service.datasource.category_info.CategoryFirestoreApi
import de.bitb.main_service.models.CategoryInfo
import de.bitb.main_service.models.VideoInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository

const val VIDEO_REPOSITORY_MOCK = "video_info_database_mock"
const val VIDEO_REPOSITORY = "video_info_database"
const val VIDEO_REPOSITORY_IN_USE = VIDEO_REPOSITORY

interface VideoInfoDataSource {
    fun getVideoInfo(brand: String, model: String, name: String): VideoInfo?

    fun addVideoInfo(info: VideoInfo)
}

@Component
class VideoFirestoreApi(override val firestore: Firestore) : FirestoreApi<VideoInfo>() {
    override val log: Logger = LoggerFactory.getLogger(VideoFirestoreApi::class.java)

    override fun getDocumentPath(obj: VideoInfo): String {
        return createPath(obj.brand, obj.model, obj.name)
    }

    fun createPath(brand: String, model: String, name: String): String {
        return "video/${brand}_${model}/${name}"
    }
}

@Repository(VIDEO_REPOSITORY)
class DBVideoInfoInfoDataSource @Autowired constructor(
    val firestoreApi: VideoFirestoreApi,
) : VideoInfoDataSource {
    override fun getVideoInfo(brand: String, model: String, name: String): VideoInfo? {
        val path = firestoreApi.createPath(brand, model, name)
        return firestoreApi.readDocument(path)
    }

    override fun addVideoInfo(info: VideoInfo) {
        firestoreApi.writeDocument(info)
    }
}