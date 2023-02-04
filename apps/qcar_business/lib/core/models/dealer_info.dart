import 'dart:convert';

import 'package:hive/hive.dart';

import 'model_data.dart';

part 'dealer_info.g.dart';

@HiveType(typeId: DEALER_INFO_TYPE_ID)
class DealerInfo extends HiveObject {
  DealerInfo({
    required this.name,
    required this.address,
  });

  static DealerInfo empty() => fromMap({});

  static DealerInfo fromMap(Map<String, dynamic> map) => DealerInfo(
        name: map[FIELD_NAME] ?? "",
        address: map[FIELD_ADDRESS] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_ADDRESS: address,
        FIELD_NAME: name,
      };

  String toJson() => jsonEncode(toMap());

  @HiveField(0)
  String name = "";
  @HiveField(1)
  String address = "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealerInfo && name == other.name && address == other.address;

  @override
  int get hashCode => name.hashCode ^ address.hashCode;
}
