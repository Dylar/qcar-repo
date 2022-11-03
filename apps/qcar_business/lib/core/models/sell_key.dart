import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'model_data.dart';

part 'sell_key.g.dart';

@HiveType(typeId: SELL_KEY_TYPE_ID)
class SellKey extends HiveObject {
  SellKey({required this.key});

  static SellKey fromScan(String scan) {
    final decodedKey = String.fromCharCodes(base64.decode(scan));
    // Map<String, dynamic> scanJson = jsonDecode(scan);
    // if (!await validateSellInfo(scanJson)) {
    //   throw Exception("sell key invalid");
    // }
    return SellKey.fromMap(jsonDecode(decodedKey));
  }

  static SellKey fromMap(Map<String, dynamic> map) =>
      SellKey(key: map[FIELD_KEY] ?? "");

  Map<String, dynamic> toMap() => {FIELD_KEY: key};

  String toJson() => jsonEncode(toMap());

  String encode() => base64.encode(toJson().codeUnits);

  @HiveField(0)
  String key = "";
}
