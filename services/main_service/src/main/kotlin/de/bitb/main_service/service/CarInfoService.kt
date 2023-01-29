package de.bitb.main_service.service

import de.bitb.main_service.datasource.car.*
import de.bitb.main_service.datasource.dealer.SALE_REPOSITORY_IN_USE
import de.bitb.main_service.datasource.dealer.SaleInfoDataSource
import de.bitb.main_service.exceptions.*
import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.CategoryInfo
import de.bitb.main_service.models.VideoInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class CarInfoService @Autowired constructor(
    @Qualifier(CAR_REPOSITORY_IN_USE) val carDS: CarInfoDataSource,
    @Qualifier(CATEGORY_REPOSITORY_IN_USE) val categoryDS: CategoryInfoDataSource,
    @Qualifier(VIDEO_REPOSITORY_IN_USE) val videoDS: VideoInfoDataSource,
) {
    private val log: Logger = LoggerFactory.getLogger(CarInfoService::class.java)

    @Throws(CarInfoException.UnknownCarException::class)
    fun getCarInfo(brand: String, model: String): CarInfo {
        return carDS.getCarInfo(brand, model)
            ?: throw CarInfoException.UnknownCarException(brand, model)
    }

    @Throws(CarInfoException::class)
    fun addCarInfo(info: CarInfo) {
        validateCarInfo(info)
        carDS.addCarInfo(info)
    }

    @Throws(CategoryInfoException.UnknownCategoryException::class)
    fun getCategoryInfo(brand: String, model: String, name: String): CategoryInfo =
        categoryDS.getCategoryInfo(brand, model, name)
            ?: throw CategoryInfoException.UnknownCategoryException(name)

    @Throws(CategoryInfoException::class)
    fun addCategoryInfo(info: CategoryInfo) {
        validateCategoryInfo(info)
        categoryDS.addCategoryInfo(info)
    }

    @Throws(VideoInfoException.UnknownVideoException::class)
    fun getVideoInfo(brand: String, model: String, category: String, name: String): VideoInfo =
        videoDS.getVideoInfo(brand, model, category, name)
            ?: throw VideoInfoException.UnknownVideoException(brand, model, name)

    @Throws(VideoInfoException::class)
    fun addVideoInfo(info: VideoInfo) {
        validateVideoInfo(info)
        videoDS.addVideoInfo(info)
    }
}