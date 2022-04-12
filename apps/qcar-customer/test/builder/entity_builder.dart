import 'package:carmanual/core/helper/json_loader.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/category_info.dart';
import 'package:carmanual/models/schema_validater.dart';
import 'package:carmanual/models/sell_info.dart';
import 'package:carmanual/models/video_info.dart';

const String BASE_TESTDATA_PATH = "test/testdata/";
const String TEST_CAR_MAJA = "car_info_maja.json";
const String TEST_CAR_FULL = "car_info_full.json";
const String TEST_VIDEO_INFO = "video_info.json";
const String TEST_SELL_INFO = "sell_info.json";
const String TEST_CATEGORY_INFO = "category_info.json";

Future<CarInfo> buildCarInfo({String name = TEST_CAR_FULL}) async {
  final json = await loadJsonFile('$BASE_TESTDATA_PATH$name');
  final valid = await validateCarInfo(json);
  if (!valid) {
    throw Exception("Car(${name}) json invalid: $json");
  }
  return CarInfo.fromMap(json);
}

Future<VideoInfo> buildVideoInfo({String name = TEST_VIDEO_INFO}) async {
  final json = await loadJsonFile('$BASE_TESTDATA_PATH$name');
  final valid = await validateVideoInfo(json);
  if (!valid) {
    throw Exception("Video(${name}) json invalid: $json");
  }
  return VideoInfo.fromMap(json);
}

Future<CategoryInfo> buildCategoryInfo(
    {String name = TEST_CATEGORY_INFO}) async {
  final json = await loadJsonFile('$BASE_TESTDATA_PATH$name');
  final valid = await validateCategoryInfo(json);
  if (!valid) {
    throw Exception("Category(${name}) json invalid: $json");
  }
  return CategoryInfo.fromMap(json);
}

Future<SellInfo> buildSellInfo({String name = TEST_SELL_INFO}) async {
  final json = await loadJsonFile('$BASE_TESTDATA_PATH$name');
  final valid = await validateSellInfo(json);
  if (!valid) {
    throw Exception("SellInfo(${name}) json invalid: $json");
  }
  return SellInfo.fromMap(json);
}
