import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'model_data.dart';

part 'sell_info.g.dart';

@HiveType(typeId: SELL_INFO_TYPE_ID)
class SellInfo extends HiveObject {
  SellInfo({
    required this.seller,
    required this.brand,
    required this.model,
    required this.carDealer,
    required this.key,
  });

  static SellInfo fromMap(Map<String, dynamic> map) => SellInfo(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        seller: map[FIELD_SELLER] ?? "",
        carDealer: map[FIELD_CAR_DEALER] ?? "",
        key: map[FIELD_KEY] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_SELLER: seller,
        FIELD_CAR_DEALER: carDealer,
        FIELD_KEY: key,
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String seller = "";
  @HiveField(3)
  String carDealer = "";
  @HiveField(4)
  String key = "";
}
