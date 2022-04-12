import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_customer/models/video_info.dart';

import '../core/environment_config.dart';
import 'model_data.dart';

part 'category_info.g.dart';

@HiveType(typeId: CATEGORY_INFO_TYPE_ID)
class CategoryInfo extends HiveObject {
  CategoryInfo({
    required this.name,
    required this.order,
    required this.description,
    required this.imagePath,
    required this.videos,
  });

  static List<CategoryInfo> fromList(List<dynamic> list) =>
      List<Map<String, dynamic>>.from(list)
          .map<CategoryInfo>((e) => CategoryInfo.fromMap(e))
          .toList();

  static CategoryInfo fromMap(Map<String, dynamic> map) => CategoryInfo(
        name: map[FIELD_NAME] ?? "",
        order: map[FIELD_ORDER] ?? 0,
        description: map[FIELD_DESC] ?? "",
        imagePath: map[FIELD_IMAGE_PATH] ?? "",
        videos: VideoInfo.fromList(
          map[FIELD_VIDEOS] ?? <VideoInfo>[],
        ),
      );

  Map<String, dynamic> toMap() => {
        FIELD_NAME: name,
        FIELD_ORDER: order,
        FIELD_DESC: description,
        FIELD_IMAGE_PATH: imagePath,
        FIELD_VIDEOS: videos,
      };

  String toJson() => jsonEncode(toMap());

  String get picUrl => "https://${EnvironmentConfig.domain}/videos/$imagePath";

  @HiveField(1)
  String name = "";
  @HiveField(2)
  int order = 0;
  @HiveField(3)
  String description = "";
  @HiveField(4)
  String imagePath = "";
  @HiveField(5)
  List<VideoInfo> videos = [];
}
