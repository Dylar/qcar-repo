import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'model_data.dart';

part 'sell_info.g.dart';

@HiveType(typeId: SELL_INFO_TYPE_ID)
class SellInfo extends HiveObject {
  SellInfo({
    required this.key,
    required this.seller,
    required this.brand,
    required this.model,
    required this.dealer,
    required this.introFilePath,
    required this.videos,
  });

  static SellInfo fromMap(Map<String, dynamic> map) {
    final parsedVideosMap = Map<String, List<dynamic>>.from(
            map[FIELD_VIDEOS] ?? <Map<String, dynamic>>{})
        .map((key, value) => MapEntry(key, List<String>.from(value)));
    return SellInfo(
      key: map[FIELD_KEY] ?? "",
      dealer: map[FIELD_DEALER] ?? "",
      seller: map[FIELD_SELLER] ?? "",
      brand: map[FIELD_BRAND] ?? "",
      model: map[FIELD_MODEL] ?? "",
      introFilePath: map[FIELD_INTRO] ?? "",
      videos: parsedVideosMap,
    );
  }

  Map<String, dynamic> toMap() => {
        FIELD_KEY: key,
        FIELD_DEALER: dealer,
        FIELD_SELLER: seller,
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_INTRO: introFilePath,
        FIELD_VIDEOS: videos,
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  String key = "";
  @HiveField(1)
  String dealer = "";
  @HiveField(2)
  String seller = "";
  @HiveField(3)
  String brand = "";
  @HiveField(4)
  String model = "";
  @HiveField(5)
  String introFilePath = "";
  @HiveField(6)
  Map<String, List<String>> videos = {};
}
