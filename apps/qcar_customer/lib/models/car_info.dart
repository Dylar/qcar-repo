import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:qcar_customer/models/category_info.dart';

import 'model_data.dart';

part 'car_info.g.dart';

@HiveType(typeId: CAR_INFO_TYPE_ID)
class CarInfo extends HiveObject {
  CarInfo({
    required this.brand,
    required this.model,
    required this.imagePath,
    required this.categories,
  });

  static CarInfo fromMap(Map<String, dynamic> map) => CarInfo(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        imagePath: map[FIELD_IMAGE_PATH] ?? "",
        categories: CategoryInfo.fromList(
            map[FIELD_CATEGORIES] ?? <Map<String, dynamic>>[]),
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_IMAGE_PATH: imagePath,
        FIELD_CATEGORIES: categories,
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String imagePath = "";
  @HiveField(3)
  List<CategoryInfo> categories = [];
}
