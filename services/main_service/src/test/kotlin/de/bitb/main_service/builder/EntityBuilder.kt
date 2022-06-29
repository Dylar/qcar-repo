package de.bitb.main_service.builder

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.registerKotlinModule
import de.bitb.main_service.exceptions.JSONValidationException
import de.bitb.main_service.loadJsonFile
import de.bitb.main_service.models.*

const val BASE_TESTDATA_PATH = "../../testdata"
const val TEST_SELL_INFO = "sell_info.json"
const val TEST_SELLER_INFO = "seller_info.json"
const val TEST_CAR_FULL = "car_info_full.json"

const val TEST_CAR_INFO = "car_info.json"
const val TEST_VIDEO_INFO = "video_info.json"
const val TEST_CATEGORY_INFO = "category_info.json"

val objMapper = ObjectMapper().registerKotlinModule()

private fun loadTestCustomerFile(jsonFile: String): String =
    loadJsonFile("$BASE_TESTDATA_PATH/customer/$jsonFile")

private fun loadTestDealerFile(jsonFile: String): String =
    loadJsonFile("$BASE_TESTDATA_PATH/dealer/$jsonFile")

fun buildCarInfo(jsonFile: String = TEST_CAR_INFO): CarInfo {
    val json = loadTestCustomerFile(jsonFile)
//    val isValid = validateCarInfoJson(json)
//    if (isValid) {
    return objMapper.readValue(json, CarInfo::class.java)
//    }
//    throw JSONValidationException.CarInfoValidationException(jsonFile)
}

fun buildEmptyCarInfo(): CarInfo = CarInfo()

fun buildCategoryInfo(jsonFile: String = TEST_CATEGORY_INFO): CategoryInfo {
    val json = loadTestCustomerFile(jsonFile)
//    val isValid = validateCategoryInfoJson(json)
//    if (isValid) {
    return objMapper.readValue(json, CategoryInfo::class.java)
//    }
//    throw JSONValidationException.CarInfoValidationException(jsonFile)
}

fun buildEmptyCategoryInfo(): CategoryInfo = CategoryInfo()

fun buildVideoInfo(jsonFile: String = TEST_VIDEO_INFO): VideoInfo {
    val json = loadTestCustomerFile(jsonFile)
//    val isValid = validateCategoryInfoJson(json)
//    if (isValid) {
    return objMapper.readValue(json, VideoInfo::class.java)
//    }
//    throw JSONValidationException.CarInfoValidationException(jsonFile)
}

fun buildEmptyVideoInfo(): VideoInfo = VideoInfo()

fun buildInvalidSellInfo(): SellInfo = SellInfo(key = "THIS IS A KEY")

fun buildSellInfo(jsonFile: String = TEST_SELL_INFO): SellInfo {
    val json = loadTestDealerFile(jsonFile)
    val isValid = validateSellInfoJson(json)
    if (isValid) {
        return objMapper.readValue(json, SellInfo::class.java)
    }
    throw JSONValidationException.SellInfoValidationException(jsonFile)
}

fun buildEmptySellerInfo(): SellerInfo = SellerInfo()

fun buildSellerInfo(jsonFile: String = TEST_SELLER_INFO): SellerInfo {
    val json = loadTestDealerFile(jsonFile)
//    val isValid = validateSellerInfoJson(json)
//    if (isValid) {
    return objMapper.readValue(json, SellerInfo::class.java)
//    }
//    throw JSONValidationException.SellInfoValidationException(jsonFile)
}
