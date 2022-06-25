package de.bitb.main_service.builder

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.registerKotlinModule
import de.bitb.main_service.exceptions.JSONValidationException
import de.bitb.main_service.loadJsonFile
import de.bitb.main_service.models.*

const val BASE_TESTDATA_PATH = "../../testdata/"
const val TEST_SELL_INFO = "sell_info.json"
const val TEST_CAR_FULL = "car_info_full.json"

const val TEST_CAR_INFO = "car_info.json"
const val TEST_VIDEO_INFO = "video_info.json"
const val TEST_CATEGORY_INFO = "category_info.json"
const val TEST_TECH_INFO = "tech_info.json"

val objMapper = ObjectMapper().registerKotlinModule()

private fun loadTestFile(jsonFile: String): String = loadJsonFile("$BASE_TESTDATA_PATH$jsonFile")

fun buildCarInfo(jsonFile: String = TEST_CAR_INFO): CarInfo {
    val json = loadTestFile(jsonFile)
//    val isValid = validateCarInfoJson(json)
//    if (isValid) {
    return objMapper.readValue(json, CarInfo::class.java)
//    }
//    throw JSONValidationException.CarInfoValidationException(jsonFile)
}

fun buildEmptyCarInfo(): CarInfo = CarInfo()

fun buildCategoryInfo(jsonFile: String = TEST_CATEGORY_INFO): CategoryInfo {
    val json = loadTestFile(jsonFile)
//    val isValid = validateCategoryInfoJson(json)
//    if (isValid) {
    return objMapper.readValue(json, CategoryInfo::class.java)
//    }
//    throw JSONValidationException.CarInfoValidationException(jsonFile)
}

fun buildEmptyCategoryInfo(): CategoryInfo = CategoryInfo()

fun buildVideoInfo(jsonFile: String = TEST_VIDEO_INFO): VideoInfo {
    val json = loadTestFile(jsonFile)
//    val isValid = validateCategoryInfoJson(json)
//    if (isValid) {
    return objMapper.readValue(json, VideoInfo::class.java)
//    }
//    throw JSONValidationException.CarInfoValidationException(jsonFile)
}

fun buildEmptyVideoInfo(): VideoInfo = VideoInfo()

fun buildTechInfo(jsonFile: String = TEST_TECH_INFO): TechInfo {
    val json = loadTestFile(jsonFile)
//    val isValid = validateCategoryInfoJson(json)
//    if (isValid) {
    return objMapper.readValue(json, TechInfo::class.java)
//    }
//    throw JSONValidationException.CarInfoValidationException(jsonFile)
}

fun buildInvalidSellInfo(): SellInfo = SellInfo(key = "THIS IS A KEY")

fun buildSellInfo(jsonFile: String = TEST_SELL_INFO): SellInfo {
    val json = loadTestFile(jsonFile)
    val isValid = validateSellInfoJson(json)
    if (isValid) {
        return objMapper.readValue(json, SellInfo::class.java)
    }
    throw JSONValidationException.SellInfoValidationException(jsonFile)
}
