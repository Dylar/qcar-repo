package de.bitb.main_service.controller

import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.CategoryInfo
import de.bitb.main_service.models.VideoInfo
import de.bitb.main_service.service.CarInfoService
import de.bitb.main_service.service.CategoryInfoService
import de.bitb.main_service.service.VideoInfoService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(CAR_URL_V1)
class CarController @Autowired constructor(
    private val carService: CarInfoService,
    private val catService: CategoryInfoService,
    private val videoService: VideoInfoService
) {
    private val log: Logger = LoggerFactory.getLogger(CarController::class.java)

    // CAR
    @GetMapping("/brand/{brand}/model/{model}")
    fun getCarInfo(@PathVariable brand: String, @PathVariable model: String): CarInfo {
        log.info("getCarInfo: $brand - $model")
        return carService.getCarInfo(brand, model)
    }

    @PostMapping("/addCar")
    @ResponseStatus(HttpStatus.CREATED)
    fun addCarInfo(@RequestBody info: CarInfo) {
        log.info("addCarInfo: $info")
        carService.addCarInfo(info)
    }

    // CATEGORY
    @GetMapping("/brand/{brand}/model/{model}/category/{name}")
    fun getCategoryInfo(
        @PathVariable brand: String,
        @PathVariable model: String,
        @PathVariable name: String
    ): CategoryInfo {
        log.info("getCategoryInfo: $brand - $model - $name")
        return catService.getCategoryInfo(brand, model, name)
    }

    @PostMapping("/addCategory")
    @ResponseStatus(HttpStatus.CREATED)
    fun addCategoryInfo(@RequestBody info: CategoryInfo) {
        log.info("addCategoryInfo: $info")
        catService.addCategoryInfo(info)
    }

    // VIDEO
    @GetMapping("/brand/{brand}/model/{model}/category/{category}/video/{name}")
    fun getVideoInfo(
        @PathVariable brand: String,
        @PathVariable model: String,
        @PathVariable category: String,
        @PathVariable name: String
    ): VideoInfo {
        log.info("addVideoInfo: $brand - $model - $category - $name")
        return videoService.getVideoInfo(brand, model, category, name)
    }

    @PostMapping("/addVideo")
    @ResponseStatus(HttpStatus.CREATED)
    fun addVideoInfo(@RequestBody info: VideoInfo) {
        log.info("addVideoInfo: $info")
        videoService.addVideoInfo(info)
    }

}