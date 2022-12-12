import 'package:qcar_business/core/models/settings.dart';
import 'package:qcar_business/core/service/settings_service.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class SettingsViewModel extends ViewModel {
  Settings get settings;

  Future saveVideoSettings(Map<String, bool> settingsMap);

  Future toggleTracking();
}

class SettingsVM extends SettingsViewModel {
  SettingsVM(this.settingsService);

  final SettingsService settingsService;

  late Settings settings;

  @override
  Future init() async {
    settings = await settingsService.getSettings();
  }

  @override
  Future saveVideoSettings(Map<String, bool> settingsMap) async {
    settings.videos = settingsMap;
    await settingsService.saveSettings(settings);
  }

  @override
  Future toggleTracking() async {
    settings.isTrackingEnabled = !settings.isTrackingEnabled!;
    await settingsService.saveSettings(settings);
    notifyListeners();
  }
}
