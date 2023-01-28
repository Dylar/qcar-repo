import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_business/core/datasource/car_database.dart';
import 'package:qcar_business/core/datasource/sale_database.dart';
import 'package:qcar_business/core/datasource/settings_database.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/settings.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_shared/utils/logger.dart';

const String BOX_SETTINGS = "SettingsBox";
const String BOX_CAR_INFO = "CarInfoBox";
const String BOX_SALE_INFO = "SaleInfoBox";

class AppDatabase with SettingsDB, SaleInfoDB, CarInfoDB {
  Future<void> close() async {
    await Hive.close();
  }

  Future<void> init() async {
    await Hive.initFlutter();
    try {
      Hive.registerAdapter(CarInfoAdapter());
      Hive.registerAdapter(VideoInfoAdapter());
      Hive.registerAdapter(SaleInfoAdapter());
      Hive.registerAdapter(SettingsAdapter());
    } catch (e) {
      Logger.logE("adapter already added");
    }
    await Hive.openBox<Settings>(BOX_SETTINGS);
    await Hive.openBox<CarInfo>(BOX_CAR_INFO);
    await Hive.openBox<SaleInfo>(BOX_SALE_INFO);

    await initSettings();
  }

  Future initSettings() async {
    final settings = await getSettings();
    await upsertSettings(settings);
  }
}
