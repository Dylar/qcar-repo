import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/models/video_info.dart';

import 'model_data.dart';

part 'sale_info.g.dart';

@HiveType(typeId: SALE_INFO_TYPE_ID)
class SaleInfo extends HiveObject {
  SaleInfo({
    required this.seller,
    required this.car,
    required this.videos,
    required this.customer,
  });

  static SaleInfo empty() => fromMap({});

  static String toListJson(List<SaleInfo> infos) =>
      jsonEncode(infos.map((e) => e.toMap()).toList());

  static SaleInfo fromMap(Map<String, dynamic> map) {
    return SaleInfo(
      seller: SellerInfo.fromMap(map),
      car: CarInfo.fromMap(map),
      customer: CustomerInfo.fromMap(map),
      videos: Map<String, List<dynamic>>.from(
        map[FIELD_VIDEOS] ?? <Map<String, dynamic>>{},
      ).map((key, value) => MapEntry(key, List<String>.from(value))),
    );
  }

  Map<String, dynamic> toMap() => {
        FIELD_SELLER: seller.toMap(),
        FIELD_CAR: car.toMap(),
        FIELD_CUSTOMER: customer.toMap(),
        FIELD_VIDEOS: videos,
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  SellerInfo seller = SellerInfo.empty();
  @HiveField(1)
  CarInfo car = CarInfo.empty();
  @HiveField(2)
  Map<String, List<String>> videos = {};
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

  SaleInfo copy({SellerInfo? seller}) {
    return SaleInfo(
        seller: seller ?? this.seller,
        car: car,
        videos: videos,
        customer: customer);
  }
}
