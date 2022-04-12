import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/models/settings.dart';

abstract class SettingsDatabase {
  Future<void> upsertSettings(Settings settings);

  Future<Settings> getSettings();
}

mixin SettingsDB implements SettingsDatabase {
  Box<Settings> get box => Hive.box<Settings>(BOX_SETTINGS);

  @override
  Future<void> upsertSettings(Settings settings) async {
    await box.put("settings", settings);
  }

  @override
  Future<Settings> getSettings() async => box.get("settings") ?? Settings();
}
