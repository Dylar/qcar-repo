import 'package:json_schema2/json_schema2.dart';
import 'package:qcar_shared/utils/json_loader.dart';

const BASE_SCHEMA_PATH = "assets/schema/";

final CAR_INFO_SCHEMA = "car_info_schema.json";
final CATEGORY_INFO_SCHEMA = "category_info_schema.json";
final VIDEO_INFO_SCHEMA = "video_info_schema.json";

final DEALER_INFO_SCHEMA = "dealer_info_schema.json";
final SELLER_INFO_SCHEMA = "seller_info_schema.json";
final SALE_INFO_SCHEMA = "sale_info_schema.json";
final SALE_KEY_SCHEMA = "sale_key_schema.json";

Future<bool> _validateSchema<T>(T entity, String file) async {
  final schemaFile = await loadJsonAsset(BASE_SCHEMA_PATH + file);
  final schema = await JsonSchema.createSchema(schemaFile);
  return schema.validate(entity);
}

Future<bool> validateCarInfo(Map<String, dynamic> json) async {
  return await _validateSchema(json, CAR_INFO_SCHEMA);
}

Future<bool> validateCategoryInfo(Map<String, dynamic> json) async {
  return await _validateSchema(json, CATEGORY_INFO_SCHEMA);
}

Future<bool> validateVideoInfo(Map<String, dynamic> json) async {
  return await _validateSchema(json, VIDEO_INFO_SCHEMA);
}

Future<bool> validateDealerInfo(Map<String, dynamic> json) async {
  return await _validateSchema(json, DEALER_INFO_SCHEMA);
}

Future<bool> validateSellerInfo(Map<String, dynamic> json) async {
  return await _validateSchema(json, SELLER_INFO_SCHEMA);
}

Future<bool> validateSaleInfo(Map<String, dynamic> json) async {
  return await _validateSchema(json, SALE_INFO_SCHEMA);
}

Future<bool> validateSaleKey(Map<String, dynamic> json) async {
  return await _validateSchema(json, SALE_KEY_SCHEMA);
}
