import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/settings.dart';
import 'package:qcar_customer/service/info_service.dart';

import '../../core/tracking.dart';

abstract class HomeViewModel extends ViewModel {
  String? introUrl;

  Stream<Settings> watchSettings();
}

class HomeVM extends HomeViewModel {
  HomeVM(
    this.settings,
    this.infoService,
  );

  final SettingsDataSource settings;
  final InfoService infoService;

  String? introUrl;

  @override
  void init() {
    super.init();
    initVideo();
  }

  Future<void> initVideo() async {
    introUrl = await infoService.getIntroVideo();
    Logger.logI("Intro: ${introUrl}");
    notifyListeners();
  }

  @override
  Stream<Settings> watchSettings() {
    return settings.watchSettings();
  }
}
