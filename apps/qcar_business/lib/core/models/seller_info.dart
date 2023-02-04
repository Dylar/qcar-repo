import 'dart:convert';

import 'package:hive/hive.dart';

import 'model_data.dart';

part 'seller_info.g.dart';

@HiveType(typeId: SELLER_INFO_TYPE_ID)
class SellerInfo extends HiveObject {
  SellerInfo({
    required this.dealer,
    required this.name,
  });

  static SellerInfo empty() => fromMap({});

  static String toListJson(List<SellerInfo> infos) =>
      jsonEncode(infos.map((e) => e.toMap()).toList());

  static SellerInfo fromMap(Map<String, dynamic> map) => SellerInfo(
        dealer: map[FIELD_DEALER] ?? "",
        name: map[FIELD_NAME] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_DEALER: dealer,
        FIELD_NAME: name,
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  String dealer = "";
  @HiveField(1)
  String name = "";

  SellerInfo copy({String? name}) => SellerInfo(
        dealer: dealer,
        name: name ?? this.name,
      );
}
