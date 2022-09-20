import 'package:qcar_customer/core/datasource/settings_data_source.dart';
import 'package:qcar_customer/core/models/settings.dart';

class SettingsService {
  SettingsService(this._settingsSource);

  SettingsDataSource _settingsSource;

  Future<Settings> getSettings() async => _settingsSource.getSettings();

  Future<bool> saveSettings(Settings settings) =>
      _settingsSource.saveSettings(settings);

  Future<bool> isTrackingEnabled() async =>
      (await getSettings()).isTrackingEnabled ?? false;

  Future<bool> isTrackingDecided() async =>
      (await getSettings()).isTrackingEnabled != null;

  Future setTrackingEnabled(trackingEnabled) async {
    final settings = await getSettings();
    settings.isTrackingEnabled = trackingEnabled;
    await _settingsSource.saveSettings(settings);
  }
}
