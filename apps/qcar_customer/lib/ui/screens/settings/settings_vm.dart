import 'package:qcar_customer/core/models/settings.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class SettingsViewModel extends ViewModel
    implements FeedbackViewModel {
  Settings get settings;

  Future saveVideoSettings(Map<String, bool> settingsMap);

  Future toggleTracking();
}

class SettingsVM extends SettingsViewModel with FeedbackFun {
  SettingsVM(this.settingsService, this.trackingService);

  @override
  final TrackingService trackingService;
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
