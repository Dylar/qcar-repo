import 'dart:convert';

import 'package:carmanual/core/environment_config.dart';
import 'package:carmanual/core/helper/etag.dart';
import 'package:hive/hive.dart';

import 'model_data.dart';

part 'video_info.g.dart';

@HiveType(typeId: VIDEO_INFO_TYPE_ID)
class VideoInfo extends HiveObject {
  VideoInfo({
    required this.brand,
    required this.model,
    required this.category,
    required this.name,
    required this.filePath,
    required this.imagePath,
    required this.description,
    required this.tags,
  });

  static List<VideoInfo> fromList(List<dynamic> list) =>
      List<Map<String, dynamic>>.from(list)
          .map<VideoInfo>((e) => VideoInfo.fromMap(e))
          .toList();

  static VideoInfo fromMap(Map<String, dynamic> map) => VideoInfo(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        category: map[FIELD_CATEGORY] ?? "",
        name: map[FIELD_NAME] ?? "",
        filePath: map[FIELD_FILE_PATH] ?? "",
        imagePath: map[FIELD_IMAGE_PATH] ?? "",
        description: map[FIELD_DESC] ?? "",
        tags: List<String>.from(map[FIELD_TAGS] ?? <String>[]),
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_CATEGORY: category,
        FIELD_NAME: name,
        FIELD_FILE_PATH: filePath,
        FIELD_IMAGE_PATH: imagePath,
        FIELD_DESC: description,
        FIELD_TAGS: tags,
      };

  String toJson() => jsonEncode(toMap());

  String get vidUrl => "https://${EnvironmentConfig.domain}/videos/$filePath";
  String get picUrl => "https://${EnvironmentConfig.domain}/videos/$imagePath";

  String get asEtag => etag(vidUrl);

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String category = "";
  @HiveField(3)
  String name = "";
  @HiveField(4)
  String filePath = "";
  @HiveField(5)
  String imagePath = "";
  @HiveField(6)
  String description = "";
  @HiveField(7)
  List<String> tags = [];
}
