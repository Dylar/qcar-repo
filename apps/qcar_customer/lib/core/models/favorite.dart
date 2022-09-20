import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_customer/core/models/model_data.dart';

part 'favorite.g.dart';

@HiveType(typeId: FAVORITE_TYPE_ID)
class Favorite extends HiveObject {
  Favorite({
    required this.brand,
    required this.model,
    required this.category,
    required this.video,
  });

  static Favorite fromMap(Map<String, dynamic> map) => Favorite(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        category: map[FIELD_CATEGORY] ?? "",
        video: map[FIELD_VIDEO] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_CATEGORY: category,
        FIELD_VIDEO: video,
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String category = "";
  @HiveField(3)
  String video = "";
}
