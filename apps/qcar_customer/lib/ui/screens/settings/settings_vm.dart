import 'package:qcar_customer/core/models/settings.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/core/service/upload_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';

abstract class SettingsViewModel extends ViewModel
    implements FeedbackViewModel {
  Settings get settings;

  saveVideoSettings(Map<String, bool> settingsMap);
}

class SettingsVM extends SettingsViewModel with FeedbackFun {
  SettingsVM(this.settingsService, this.uploadService);

  @override
  final UploadService uploadService;
  final SettingsService settingsService;

  late Settings settings;

  @override
  Future init() async {
    settings = await settingsService.getSettings();
  }

  @override
  saveVideoSettings(Map<String, bool> settingsMap) {
    throw UnimplementedError();
  }
}
