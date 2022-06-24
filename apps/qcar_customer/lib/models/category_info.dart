import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_customer/models/video_info.dart';

import '../core/environment_config.dart';
import 'model_data.dart';

part 'category_info.g.dart';

@HiveType(typeId: CATEGORY_INFO_TYPE_ID)
class CategoryInfo extends HiveObject {
  CategoryInfo({
    required this.brand,
    required this.model,
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
        brand: map[FIELD_BRAND] ?? "",
        model: map[FIELD_MODEL] ?? "",
        name: map[FIELD_NAME] ?? "",
        order: int.tryParse(map[FIELD_ORDER].toString() ?? '0') ?? 0,
        description: map[FIELD_DESC] ?? "",
        imagePath: map[FIELD_IMAGE_PATH] ?? "",
        videos: VideoInfo.fromList(
          map[FIELD_VIDEOS] ?? <VideoInfo>[],
        ),
      );

  Map<String, dynamic> toMap() => {
        FIELD_BRAND: brand,
        FIELD_MODEL: model,
        FIELD_NAME: name,
        FIELD_ORDER: order,
        FIELD_DESC: description,
        FIELD_IMAGE_PATH: imagePath,
        FIELD_VIDEOS: videos,
      };

  String toJson() => jsonEncode(toMap());

  String get picUrl => "https://${EnvironmentConfig.domain}/videos/$imagePath";

  @HiveField(1)
  String brand = "";
  @HiveField(2)
  String model = "";
  @HiveField(3)
  String name = "";
  @HiveField(4)
  int order = 0;
  @HiveField(5)
  String description = "";
  @HiveField(6)
  String imagePath = "";
  @HiveField(7)
  List<VideoInfo> videos = [];
}
