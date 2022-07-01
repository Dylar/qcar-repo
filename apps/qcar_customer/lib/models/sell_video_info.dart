import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:qcar_customer/core/environment_config.dart';

import 'model_data.dart';

part 'sell_video_info.g.dart';

@HiveType(typeId: SELL_VIDEO_INFO_TYPE_ID)
class SellVideoInfo extends HiveObject {
  SellVideoInfo({
    required this.category,
    required this.name,
    required this.filePath,
  });

  SellVideoInfo.empty() {
    SellVideoInfo(category: "", name: "", filePath: "");
  }

  static List<SellVideoInfo> fromList(List<dynamic> list) =>
      List<Map<String, dynamic>>.from(list)
          .map<SellVideoInfo>((e) => SellVideoInfo.fromMap(e))
          .toList();

  static SellVideoInfo fromMap(Map<String, dynamic> map) => SellVideoInfo(
        category: map[FIELD_CATEGORY] ?? "",
        name: map[FIELD_NAME] ?? "",
        filePath: map[FIELD_FILE_PATH] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_CATEGORY: category,
        FIELD_NAME: name,
        FIELD_FILE_PATH: filePath,
      };

  String toJson() => jsonEncode(toMap());

  String get vidUrl => "https://${EnvironmentConfig.domain}/videos/$filePath";

  @HiveField(0)
  String category = "";
  @HiveField(1)
  String name = "";
  @HiveField(2)
  String filePath = "";
}
