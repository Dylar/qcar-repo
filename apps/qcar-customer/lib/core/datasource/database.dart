import 'package:carmanual/core/datasource/CarInfoDatabase.dart';
import 'package:carmanual/core/datasource/SettingsDatabase.dart';
import 'package:carmanual/core/datasource/VideoInfoDatabase.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/category_info.dart';
import 'package:carmanual/models/settings.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../tracking.dart';

class DatabaseOpenException implements Exception {}

class DatabaseClosedException implements Exception {}

const String BOX_SETTINGS = "SettingsBox";
const String BOX_CAR_INFO = "CarInfoBox";
const String BOX_CATEGORY_INFO = "CategoryInfoBox";
const String BOX_VIDEO_INFO = "VideoInfoBox";

class AppDatabase with SettingsDB, CarInfoDB, VideoInfoDB {
  Future<void> init() async {
    await Hive.initFlutter();
    try {
      Hive.registerAdapter(CarInfoAdapter());
      Hive.registerAdapter(VideoInfoAdapter());
      Hive.registerAdapter(CategoryInfoAdapter());
      Hive.registerAdapter(SettingsAdapter());
    } catch (e) {
      Logger.logE("adapter already added");
    }
    await Hive.openBox<Settings>(BOX_SETTINGS);
    await Hive.openBox<CarInfo>(BOX_CAR_INFO);
    await Hive.openBox<CategoryInfo>(BOX_CATEGORY_INFO);
    await Hive.openBox<VideoInfo>(BOX_VIDEO_INFO);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
