import 'package:json_schema2/json_schema2.dart';
import 'package:qcar_business/core/misc/helper/json_loader.dart';

const BASE_SCHEMA_PATH = "assets/schema/";
final SELL_INFO_SCHEMA = "sell_info_schema.json";
final SELL_KEY_SCHEMA = "sell_key_schema.json";
final CAR_INFO_SCHEMA = "car_info_schema.json";
final CATEGORY_INFO_SCHEMA = "category_info_schema.json";
final VIDEO_INFO_SCHEMA = "video_info_schema.json";

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

Future<bool> validateSellInfo(Map<String, dynamic> json) async {
  return await _validateSchema(json, SELL_INFO_SCHEMA);
}

Future<bool> validateSellKey(Map<String, dynamic> json) async {
  return await _validateSchema(json, SELL_KEY_SCHEMA);
}
