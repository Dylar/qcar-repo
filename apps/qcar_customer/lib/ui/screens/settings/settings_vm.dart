import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/models/settings.dart';
import 'package:qcar_customer/service/settings_service.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';

abstract class SettingsViewModel extends ViewModel
    implements FeedbackViewModel {
  Settings get settings;

  saveVideoSettings(Map<String, bool> settingsMap);
}

class SettingsVM extends SettingsViewModel with FeedbackFun {
  SettingsVM(this.settingsService, this.uploadService, this.settingsSource);

  @override
  final UploadService uploadService;
  final SettingsService settingsService;
  final SettingsDataSource settingsSource;

  late Settings settings;

  @override
  Future init() async {
    settings = await settingsSource.getSettings();
  }

  @override
  saveVideoSettings(Map<String, bool> settingsMap) {
    throw UnimplementedError();
  }
}
