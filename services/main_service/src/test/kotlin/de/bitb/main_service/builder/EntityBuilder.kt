package de.bitb.main_service.builder

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.registerKotlinModule
import de.bitb.main_service.exceptions.JSONValidationException
import de.bitb.main_service.loadJsonFile
import de.bitb.main_service.models.*

const val BASE_TESTDATA_PATH = "../../testdata"
const val TEST_DEALER_INFO = "dealer_info.json"
const val TEST_CAR_LINK = "car_link.json"
const val TEST_SELLER_INFO = "seller_info.json"
const val TEST_SELL_INFO = "sell_info.json"
const val TEST_SELL_INFO_WITHOUT_KEY = "sell_info_without_key.json"

const val TEST_CAR_FULL = "car_info_full.json"
const val TEST_CAR_INFO = "car_info.json"
const val TEST_VIDEO_INFO = "video_info.json"
const val TEST_CATEGORY_INFO = "category_info.json"

const val TEST_FEEDBACK = "feedback.json"
//TODO until now feedback and tracking json is the same
const val TEST_TRACKING = "feedback.json"

val objMapper: ObjectMapper = ObjectMapper().registerKotlinModule()
    .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)

private fun loadTestCustomerFile(jsonFile: String): String =
    loadJsonFile("$BASE_TESTDATA_PATH/customer/$jsonFile")

private fun loadTestDealerFile(jsonFile: String): String =
    loadJsonFile("$BASE_TESTDATA_PATH/dealer/$jsonFile")

private fun loadTestTrackingFile(jsonFile: String): String =
    loadJsonFile("$BASE_TESTDATA_PATH/tracking/$jsonFile")

fun buildEmptyCarInfo(): CarInfo = CarInfo()
fun buildCarInfo(jsonFile: String = TEST_CAR_INFO): CarInfo {
    val json = loadTestCustomerFile(jsonFile)
    return objMapper.readValue(json, CarInfo::class.java)
}

fun buildEmptyCategoryInfo(): CategoryInfo = CategoryInfo()
fun buildCategoryInfo(jsonFile: String = TEST_CATEGORY_INFO): CategoryInfo {
    val json = loadTestCustomerFile(jsonFile)
    return objMapper.readValue(json, CategoryInfo::class.java)
}

fun buildEmptyVideoInfo(): VideoInfo = VideoInfo()
fun buildVideoInfo(jsonFile: String = TEST_VIDEO_INFO): VideoInfo {
    val json = loadTestCustomerFile(jsonFile)
    return objMapper.readValue(json, VideoInfo::class.java)
}

fun buildEmptyDealerInfo(): DealerInfo = DealerInfo()
fun buildDealerInfo(jsonFile: String = TEST_DEALER_INFO): DealerInfo {
    val json = loadTestDealerFile(jsonFile)
    return objMapper.readValue(json, DealerInfo::class.java)
}

fun buildEmptyCarLink(): CarLink = CarLink()
fun buildCarLink(jsonFile: String = TEST_CAR_LINK): CarLink {
    val json = loadTestDealerFile(jsonFile)
    return objMapper.readValue(json, CarLink::class.java)
}

fun buildEmptySellerInfo(): SellerInfo = SellerInfo()
fun buildSellerInfo(jsonFile: String = TEST_SELLER_INFO): SellerInfo {
    val json = loadTestDealerFile(jsonFile)
    return objMapper.readValue(json, SellerInfo::class.java)
}

fun buildInvalidSellInfo(): SellInfo = SellInfo(key = "THIS IS A KEY")
fun buildSellInfo(jsonFile: String = TEST_SELL_INFO_WITHOUT_KEY): SellInfo {
    val json = loadTestDealerFile(jsonFile)
    val isValid = validateSellInfoJson(json)
    if (isValid) {
        return objMapper.readValue(json, SellInfo::class.java)
    }
    throw JSONValidationException.SellInfoValidationException(jsonFile)
}

fun buildEmptyFeedback(): Feedback = Feedback()
fun buildFeedback(jsonFile: String = TEST_FEEDBACK): Feedback {
    val json = loadTestTrackingFile(jsonFile)
    return objMapper.readValue(json, Feedback::class.java)
}

fun buildEmptyTracking(): Tracking = Tracking()
fun buildTracking(jsonFile: String = TEST_TRACKING): Tracking {
    val json = loadTestTrackingFile(jsonFile)
    return objMapper.readValue(json, Tracking::class.java)
}