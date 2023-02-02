import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_shared/utils/json_loader.dart';

const String BASE_TESTDATA_PATH = "../../testdata";
const String DEALER_TESTDATA_PATH = "$BASE_TESTDATA_PATH/dealer/";
const String CUSTOMER_TESTDATA_PATH = "$BASE_TESTDATA_PATH/car/";
const String TEST_CAR_MAJA = "car_info_maja.json";

const String TEST_CAR_FULL = "car_info_full.json";
const String TEST_VIDEO_INFO = "video_info.json";

const String TEST_DEALER_INFO = "dealer_info.json";
const String TEST_SELLER_INFO = "seller_info.json";
const String TEST_SALE_INFO = "sale_info.json";
const String TEST_SALE_KEY = "sale_key.json";

Future<CarInfo> buildCarWith({
  String brand = "new",
  String model = "newer",
}) async {
  final car = await buildCarInfo();
  return car
    ..brand = brand
    ..model = model;
}

Future<CarInfo> buildCarInfo({String name = TEST_CAR_FULL}) async {
  final json = await loadJsonFile('$CUSTOMER_TESTDATA_PATH$name');
  // final valid = await validateCarInfo(json);
  // if (!valid) {
  //   throw Exception("Car(${name}) json invalid: $json");
  // }
  return CarInfo.fromMap(json);
}

Future<VideoInfo> buildVideoInfo({String name = TEST_VIDEO_INFO}) async {
  final json = await loadJsonFile('$CUSTOMER_TESTDATA_PATH$name');
  // final valid = await validateVideoInfo(json);
  // if (!valid) {
  //   throw Exception("Video(${name}) json invalid: $json");
  // }
  return VideoInfo.fromMap(json);
}

Future<DealerInfo> buildDealerInfo({String name = TEST_DEALER_INFO}) async {
  final json = await loadJsonFile('$DEALER_TESTDATA_PATH$name');
  // final valid = await validateDealerInfo(json);
  // if (!valid) {
  //   throw Exception("Dealer(${name}) json invalid: $json");
  // }
  return DealerInfo.fromMap(json);
}

Future<SellerInfo> buildSellerInfo({String name = TEST_SELLER_INFO}) async {
  final json = await loadJsonFile('$DEALER_TESTDATA_PATH$name');
  // final valid = await validateSellerInfo(json);
  // if (!valid) {
  //   throw Exception("Seller(${name}) json invalid: $json");
  // }
  return SellerInfo.fromMap(json);
}

Future<SaleInfo> buildSaleWith({
  CarInfo? car,
}) async {
  final sale = await buildSaleInfo();
  return sale..car = car ?? CarInfo.empty();
}

Future<SaleInfo> buildSaleInfo({String name = TEST_SALE_INFO}) async {
  final json = await loadJsonFile('$DEALER_TESTDATA_PATH$name');
  // final valid = await validateSaleInfo(json);
  // if (!valid) {
  //   throw Exception("SaleInfo(${name}) json invalid: $json");
  // }
  return SaleInfo.fromMap(json);
}
