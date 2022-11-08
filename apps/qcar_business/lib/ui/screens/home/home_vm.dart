import 'dart:async';

import 'package:qcar_business/core/service/settings_service.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class HomeViewModel extends ViewModel {}

class HomeVM extends HomeViewModel {
  HomeVM(this.settingsService);

  @override
  SettingsService settingsService;

  @override
  Future init() async {}
}
