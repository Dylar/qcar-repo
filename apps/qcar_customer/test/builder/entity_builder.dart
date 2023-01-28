import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/category_info.dart';
import 'package:qcar_customer/core/models/sale_info.dart';
import 'package:qcar_customer/core/models/sale_key.dart';
import 'package:qcar_customer/core/models/schema_validator.dart';
import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_shared/utils/json_loader.dart';

const String BASE_TESTDATA_PATH = "../../testdata";
const String DEALER_TESTDATA_PATH = "$BASE_TESTDATA_PATH/dealer/";
const String CUSTOMER_TESTDATA_PATH = "$BASE_TESTDATA_PATH/car/";
const String TEST_CAR_MAJA = "car_info_maja.json";
const String TEST_CAR_FULL = "car_info_full.json";
const String TEST_VIDEO_INFO = "video_info.json";
const String TEST_SALE_INFO = "sale_info.json";
const String TEST_SALE_KEY = "sale_key.json";
const String TEST_CATEGORY_INFO = "category_info.json";

Future<CarInfo> buildCarWith({
  String brand = "new",
  String model = "newer",
}) async {
  final car = await buildCarInfo();
  car.categories.forEach((cat) {
    cat.brand = brand;
    cat.model = model;
    cat.videos.forEach((vid) {
      vid.brand = brand;
      vid.model = model;
    });
  });
  return car
    ..brand = brand
    ..model = model;
}

Future<CarInfo> buildCarInfo({String name = TEST_CAR_FULL}) async {
  final json = await loadJsonFile('$CUSTOMER_TESTDATA_PATH$name');
  final valid = await validateCarInfo(json);
  if (!valid) {
    throw Exception("Car(${name}) json invalid: $json");
  }
  return CarInfo.fromMap(json);
}

Future<VideoInfo> buildVideoInfo({String name = TEST_VIDEO_INFO}) async {
  final json = await loadJsonFile('$CUSTOMER_TESTDATA_PATH$name');
  final valid = await validateVideoInfo(json);
  if (!valid) {
    throw Exception("Video(${name}) json invalid: $json");
  }
  return VideoInfo.fromMap(json);
}

Future<CategoryInfo> buildCategoryInfo(
    {String name = TEST_CATEGORY_INFO}) async {
  final json = await loadJsonFile('$CUSTOMER_TESTDATA_PATH$name');
  final valid = await validateCategoryInfo(json);
  if (!valid) {
    throw Exception("Category(${name}) json invalid: $json");
  }
  return CategoryInfo.fromMap(json);
}

Future<SaleInfo> buildSaleWith({
  String brand = "new",
  String model = "newer",
}) async {
  final sale = await buildSaleInfo();
  return sale
    ..brand = brand
    ..model = model;
}

Future<SaleInfo> buildSaleInfo({String name = TEST_SALE_INFO}) async {
  final json = await loadJsonFile('$DEALER_TESTDATA_PATH$name');
  final valid = await validateSaleInfo(json);
  if (!valid) {
    throw Exception("SaleInfo(${name}) json invalid: $json");
  }
  return SaleInfo.fromMap(json);
}

Future<SaleKey> buildSaleKey({String name = TEST_SALE_KEY}) async {
  final json = await loadJsonFile('$DEALER_TESTDATA_PATH$name');
  final valid = await validateSaleKey(json);
  if (!valid) {
    throw Exception("buildSaleKey(${name}) json invalid: $json");
  }
  return SaleKey.fromMap(json);
}
