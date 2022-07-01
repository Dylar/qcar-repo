import 'package:provider/provider.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/settings.dart';
import 'package:qcar_customer/service/info_service.dart';

import '../../core/tracking.dart';

class HomeViewModelProvider extends ChangeNotifierProvider<HomeProvider> {
  HomeViewModelProvider(SettingsDataSource settings, InfoService carInfoService)
      : super(create: (_) => HomeProvider(HomeVM(settings, carInfoService)));
}

class HomeProvider extends ViewModelProvider<HomeViewModel> {
  HomeProvider(HomeViewModel viewModel) : super(viewModel);
}

abstract class HomeViewModel extends ViewModel {
  String? introUrl;

  Stream<Settings> watchSettings();
}

class HomeVM extends HomeViewModel {
  HomeVM(
    this.settings,
    this.carInfoService,
  );

  final SettingsDataSource settings;
  final InfoService carInfoService;

  @override
  void init() {
    super.init();
    initVideo();
  }

  Future<void> initVideo() async {
    introUrl = await carInfoService.getIntroVideo();
    Logger.logI("Intro: ${introUrl}");
    notifyListeners();
  }

  @override
  Stream<Settings> watchSettings() {
    return settings.watchSettings();
  }
}
