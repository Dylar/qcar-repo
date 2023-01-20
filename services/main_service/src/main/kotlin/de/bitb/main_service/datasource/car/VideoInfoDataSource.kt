package de.bitb.main_service.datasource.car

import com.google.cloud.firestore.Firestore
import de.bitb.main_service.datasource.firestore.FirestoreApi
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
    fun getVideoInfo(brand: String, model: String, category: String, name: String): VideoInfo?

    fun addVideoInfo(info: VideoInfo)
}

@Component
class VideoFirestoreApi(override val firestore: Firestore) : FirestoreApi<VideoInfo>() {
    override val log: Logger = LoggerFactory.getLogger(VideoFirestoreApi::class.java)

    override fun getDocumentPath(obj: VideoInfo): String =
        "${getCollectionPath(obj.brand, obj.model, obj.category)}/${obj.name}"

    fun getCollectionPath(brand: String, model: String, category: String): String =
        "car/${brand}/model/${model}/category/${category}/video"
}

@Repository(VIDEO_REPOSITORY)
class DBVideoInfoInfoDataSource @Autowired constructor(
    val firestoreApi: VideoFirestoreApi,
) : VideoInfoDataSource {
    override fun getVideoInfo(
        brand: String,
        model: String,
        category: String,
        name: String
    ): VideoInfo? {
        val path = firestoreApi.getCollectionPath(brand, model, category)
        return firestoreApi.getDocument(path) {
            it.whereEqualTo("name", name)
        }
    }

    override fun addVideoInfo(info: VideoInfo) {
        firestoreApi.writeDocument(info)
    }
}