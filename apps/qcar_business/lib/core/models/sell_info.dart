import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/models/video_info.dart';

import 'model_data.dart';

part 'sell_info.g.dart';

@HiveType(typeId: SELL_INFO_TYPE_ID)
class SellInfo extends HiveObject {
  SellInfo({
    required this.seller,
    required this.car,
    required this.videos,
    required this.customer,
  });

  static SellInfo fromMap(Map<String, dynamic> map) {
    final videosMap = Map<String, List<dynamic>>.from(
      map[FIELD_VIDEOS] ?? <Map<String, dynamic>>{},
    ).map(
      (key, value) => MapEntry(
        key,
        List<Map<String, dynamic>>.from(value)
            .map((e) => VideoInfo.fromMap(e))
            .toList(),
      ),
    );
    return SellInfo(
      seller: SellerInfo.fromMap(map),
      car: CarInfo.fromMap(map),
      customer: CustomerInfo.fromMap(map),
      videos: videosMap,
    );
  }

  Map<String, dynamic> toMap() => {
        FIELD_SELLER: seller.toMap(),
        FIELD_CAR: car.toMap(),
        FIELD_CUSTOMER: customer.toMap(),
        FIELD_VIDEOS: videos.map<String, List<Map<String, dynamic>>>(
          (key, value) => MapEntry(
            key,
            value.map((e) => e.toMap()).toList(),
          ),
        ),
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  SellerInfo seller = SellerInfo.empty();
  @HiveField(1)
  CarInfo car = CarInfo.empty();
  @HiveField(2)
  Map<String, List<VideoInfo>> videos = {};
  @HiveField(3)
  CustomerInfo customer = CustomerInfo.empty();

  String get text =>
      customer.name +
      " " +
      customer.lastName +
      " - " +
      car.brand +
      " " +
      car.model;
}
