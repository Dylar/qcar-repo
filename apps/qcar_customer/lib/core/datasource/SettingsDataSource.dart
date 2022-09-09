import 'dart:async';

import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/models/settings.dart';

abstract class SettingsDataSource {
  Future<bool> saveSettings(Settings settings);

  Future<Settings> getSettings();

  Future<Map<String, bool>> getVideoSettings();

  Stream<Settings> watchSettings();
}

class SettingsDS implements SettingsDataSource {
  SettingsDS(this._database);

  final AppDatabase _database;

  @override
  Future<Map<String, bool>> getVideoSettings() async {
    final settings = await _database.getSettings();
    return settings.videos;
  }

  @override
  Future<Settings> getSettings() async {
    final settings = await _database.getSettings();
    return settings;
  }

  @override
  Future<bool> saveSettings(Settings settings) async {
    await _database.upsertSettings(settings);
    return true;
  }

  @override
  Stream<Settings> watchSettings() async* {
    yield await _database.getSettings();
  }
}
