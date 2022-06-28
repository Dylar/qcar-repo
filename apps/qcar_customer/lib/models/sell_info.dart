import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_customer/models/video_info.dart';

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
    required this.videos,
  });

  static SellInfo fromMap(Map<String, dynamic> map) => SellInfo(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        seller: map[FIELD_SELLER] ?? "",
        carDealer: map[FIELD_CAR_DEALER] ?? "",
        key: map[FIELD_KEY] ?? "",
        videos:
            VideoInfo.fromList(map[FIELD_VIDEOS] ?? <Map<String, dynamic>>[]),
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_SELLER: seller,
        FIELD_CAR_DEALER: carDealer,
        FIELD_KEY: key,
        FIELD_VIDEOS: videos,
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
  @HiveField(5)
  List<VideoInfo> videos = [];
}
