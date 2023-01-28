import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'model_data.dart';

part 'sale_key.g.dart';

@HiveType(typeId: SALE_KEY_TYPE_ID)
class SaleKey extends HiveObject {
  SaleKey({required this.key});

  static SaleKey fromScan(String scan) {
    final decodedKey = String.fromCharCodes(base64.decode(scan));
    // Map<String, dynamic> scanJson = jsonDecode(scan);
    // if (!await validateSellInfo(scanJson)) {
    //   throw Exception("sell key invalid");
    // }
    return SaleKey.fromMap(jsonDecode(decodedKey));
  }

  static SaleKey fromMap(Map<String, dynamic> map) =>
      SaleKey(key: map[FIELD_KEY] ?? "");

  Map<String, dynamic> toMap() => {FIELD_KEY: key};

  String toJson() => jsonEncode(toMap());

  String encode() => base64.encode(toJson().codeUnits);

  @HiveField(0)
  String key = "";
}
