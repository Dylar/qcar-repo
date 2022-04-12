import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/settings.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:carmanual/service/car_info_service.dart';
import 'package:provider/provider.dart';

import '../../core/tracking.dart';

class HomeViewModelProvider extends ChangeNotifierProvider<HomeProvider> {
  HomeViewModelProvider(
      SettingsDataSource settings, CarInfoService carInfoService)
      : super(create: (_) => HomeProvider(HomeVM(settings, carInfoService)));
}

class HomeProvider extends ViewModelProvider<HomeViewModel> {
  HomeProvider(HomeViewModel viewModel) : super(viewModel);
}

abstract class HomeViewModel extends ViewModel {
  VideoInfo? introVideo;
  Stream<Settings> watchSettings();
}

class HomeVM extends HomeViewModel {
  HomeVM(
    this.settings,
    this.carInfoService,
  );

  final SettingsDataSource settings;
  final CarInfoService carInfoService;

  @override
  void init() {
    super.init();
    initVideo();
  }

  Future<void> initVideo() async {
    introVideo = await carInfoService.getIntroVideo();
    Logger.logI("Intro: ${introVideo!.vidUrl}");
    notifyListeners();
  }

  @override
  Stream<Settings> watchSettings() {
    return settings.watchSettings();
  }
}
