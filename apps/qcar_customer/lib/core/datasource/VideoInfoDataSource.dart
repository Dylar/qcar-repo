import 'dart:async';

import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/video_info.dart';

abstract class VideoInfoDataSource {
  Future<List<VideoInfo>> getVideos(CarInfo carInfo);

  Future<bool> upsertVideo(VideoInfo video);

  Future<bool> hasVideosLoaded(CarInfo carInfo);
}

class VideoInfoDS implements VideoInfoDataSource {
  VideoInfoDS(this._database);

  final AppDatabase _database;

  @override
  Future<List<VideoInfo>> getVideos(CarInfo carInfo) async {
    final videos = await _database.getVideoInfos(carInfo);
    return videos..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<bool> upsertVideo(VideoInfo video) async {
    final data = await _database.getVideoInfo(video.asEtag);
    if (data == null) {
      await _database.upsertVideoInfo(video);
    }
    return true;
  }

  @override
  Future<bool> hasVideosLoaded(CarInfo carInfo) async {
    final video = await _database.getVideoInfos(carInfo);
    return video.isNotEmpty;
  }
}
