import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:qcar_business/core/environment_config.dart';

import 'model_data.dart';

part 'video_info.g.dart';

@HiveType(typeId: VIDEO_INFO_TYPE_ID)
class VideoInfo extends HiveObject {
  VideoInfo({
    required this.brand,
    required this.model,
    required this.category,
    required this.name,
    required this.categoryImagePath,
    required this.videoImagePath,
  });

  static List<VideoInfo> fromList(List<dynamic> list) => List<String>.from(list)
      .map<Map<String, dynamic>>((e) => jsonDecode(e))
      .map<VideoInfo>((e) => VideoInfo.fromMap(e))
      .toList();

  static VideoInfo fromMap(Map<String, dynamic> map) => VideoInfo(
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        category: map[FIELD_CATEGORY] ?? "",
        name: map[FIELD_NAME] ?? "",
        categoryImagePath: map[FIELD_CATEGORY_IMAGE_PATH] ?? "",
        videoImagePath: map[FIELD_VIDEO_IMAGE_PATH] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_CATEGORY: category,
        FIELD_NAME: name,
        FIELD_CATEGORY_IMAGE_PATH: categoryImagePath,
        FIELD_VIDEO_IMAGE_PATH: videoImagePath,
      };

  String toJson() => jsonEncode(toMap());

  String get categoryImageUrl =>
      "https://${EnvironmentConfig.domain}/videos/$categoryImagePath";

  String get videoImageUrl =>
      "https://${EnvironmentConfig.domain}/videos/$videoImagePath";

  @HiveField(0)
  String brand = "";
  @HiveField(1)
  String model = "";
  @HiveField(2)
  String category = "";
  @HiveField(3)
  String name = "";
  @HiveField(4)
  String categoryImagePath = "";
  @HiveField(5)
  String videoImagePath = "";
}
