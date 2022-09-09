import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/models/settings.dart';

class SettingsService {
  SettingsService(this._settingsSource);

  SettingsDataSource _settingsSource;

  Future<bool> isTrackingEnabled() async =>
      (await _settingsSource.getSettings()).isTrackingEnabled;

  Future<Settings> getSettings() async => _settingsSource.getSettings();
}
