import 'package:carmanual/core/datasource/database.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class VideoInfoDatabase {
  Future<void> upsertVideoInfo(VideoInfo videoInfo);

  Future<List<VideoInfo>> getVideoInfos(CarInfo carInfo);

  Future<VideoInfo?> getVideoInfo(String name);
}

mixin VideoInfoDB implements VideoInfoDatabase {
  Box<VideoInfo> get videoInfoBox => Hive.box<VideoInfo>(BOX_VIDEO_INFO);

  @override
  Future<void> upsertVideoInfo(VideoInfo videoInfo) async {
    await videoInfoBox.put(
      videoInfo.asEtag,
      videoInfo,
    );
  }

  @override
  Future<List<VideoInfo>> getVideoInfos(CarInfo carInfo) async {
    return videoInfoBox.values
        .where((vid) =>
            vid.vidUrl.contains(carInfo.brand) &&
            vid.vidUrl.contains(carInfo.model))
        .toList();
  }

  @override
  Future<VideoInfo?> getVideoInfo(String etag) async {
    return videoInfoBox.get(etag);
  }
}
