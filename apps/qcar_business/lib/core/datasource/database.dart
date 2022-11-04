import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_business/core/datasource/car_database.dart';
import 'package:qcar_business/core/datasource/favorite_database.dart';
import 'package:qcar_business/core/datasource/sell_database.dart';
import 'package:qcar_business/core/datasource/settings_database.dart';
import 'package:qcar_business/core/misc/helper/player_config.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/category_info.dart';
import 'package:qcar_business/core/models/favorite.dart';
import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/core/models/settings.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_shared/utils/logger.dart';

const String BOX_SETTINGS = "SettingsBox";
const String BOX_CAR_INFO = "CarInfoBox";
const String BOX_SELL_INFO = "SellInfoBox";
const String BOX_FAVORITE = "FavoriteBox";

class AppDatabase with SettingsDB, SellInfoDB, CarInfoDB, FavoriteDB {
  Future<void> close() async {
    await Hive.close();
  }

  Future<void> init() async {
    await Hive.initFlutter();
    try {
      Hive.registerAdapter(CarInfoAdapter());
      Hive.registerAdapter(VideoInfoAdapter());
      Hive.registerAdapter(CategoryInfoAdapter());
      Hive.registerAdapter(FavoriteAdapter());
      Hive.registerAdapter(SellInfoAdapter());
      Hive.registerAdapter(SettingsAdapter());
    } catch (e) {
      Logger.logE("adapter already added");
    }
    await Hive.openBox<Settings>(BOX_SETTINGS);
    await Hive.openBox<CarInfo>(BOX_CAR_INFO);
    await Hive.openBox<SellInfo>(BOX_SELL_INFO);
    await Hive.openBox<Favorite>(BOX_FAVORITE);

    await initSettings();
  }

  Future initSettings() async {
    final settings = await getSettings();
    final vidSettings = initPlayerSettings();

    if (settings.videos.isEmpty || //TODO make anders -> ab in settings service
        settings.videos.length != vidSettings.length) {
      settings.videos = vidSettings;
      await upsertSettings(settings);
    }
  }
}
