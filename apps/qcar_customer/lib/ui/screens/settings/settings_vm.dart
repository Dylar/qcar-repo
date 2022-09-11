import 'package:qcar_customer/core/models/settings.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';

abstract class SettingsViewModel extends ViewModel
    implements FeedbackViewModel {
  Settings get settings;

  Future saveVideoSettings(Map<String, bool> settingsMap);
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
}
