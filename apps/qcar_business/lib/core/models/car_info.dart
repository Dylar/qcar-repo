import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:qcar_business/core/environment_config.dart';

import 'model_data.dart';

part 'car_info.g.dart';

@HiveType(typeId: CAR_INFO_TYPE_ID)
class CarInfo extends HiveObject {
  CarInfo({
    required this.brand,
    required this.model,
    required this.imagePath,
  });

  static CarInfo empty() => fromMap({});

  static CarInfo fromMap(Map<String, dynamic> map) => CarInfo(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        imagePath: map[FIELD_IMAGE_PATH] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_IMAGE_PATH: imagePath,
      };

  String toJson() => jsonEncode(toMap());

  String get picUrl => "https://${EnvironmentConfig.domain}/videos/$imagePath";

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String imagePath = "";
}
