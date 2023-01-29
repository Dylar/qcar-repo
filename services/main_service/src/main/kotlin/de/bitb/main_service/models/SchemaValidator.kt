package de.bitb.main_service.models

//const BASE_SCHEMA_PATH = "assets/schema/"
const val SALE_INFO_SCHEMA = "sale_info_schema.json"
const val CAR_INFO_SCHEMA = "car_info_schema.json"

////
////TODO make real validation
//fun validateJsonSchema(entity: String, file: String): Boolean {
////  final schemaFile = await loadJsonAsset(BASE_SCHEMA_PATH + file);
////  final schema = await JsonSchema.createSchema(schemaFile);
////  return schema.validate(entity);
//    return true
//}
//
//fun validateSaleInfoJson(entity: String): Boolean = validateJsonSchema(entity, SALE_INFO_SCHEMA)
//fun validateCarInfoJson(entity: String): Boolean = validateJsonSchema(entity, CAR_INFO_SCHEMA)