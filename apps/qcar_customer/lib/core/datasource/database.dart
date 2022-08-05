import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_customer/core/datasource/CarInfoDatabase.dart';
import 'package:qcar_customer/core/datasource/SellInfoDatabase.dart';
import 'package:qcar_customer/core/datasource/SettingsDatabase.dart';
import 'package:qcar_customer/core/logger.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/settings.dart';
import 'package:qcar_customer/models/video_info.dart';

class DatabaseOpenException implements Exception {}

class DatabaseClosedException implements Exception {}

const String BOX_SETTINGS = "SettingsBox";
const String BOX_CAR_INFO = "CarInfoBox";
const String BOX_SELL_INFO = "SellInfoBox";

class AppDatabase with SettingsDB, SellInfoDB, CarInfoDB {
  Future<void> init() async {
    await Hive.initFlutter();
    try {
      Hive.registerAdapter(CarInfoAdapter());
      Hive.registerAdapter(VideoInfoAdapter());
      Hive.registerAdapter(CategoryInfoAdapter());
      Hive.registerAdapter(SellInfoAdapter());
      Hive.registerAdapter(SettingsAdapter());
    } catch (e) {
      Logger.logE("adapter already added");
    }
    await Hive.openBox<Settings>(BOX_SETTINGS);
    await Hive.openBox<CarInfo>(BOX_CAR_INFO);
    await Hive.openBox<SellInfo>(BOX_SELL_INFO);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
