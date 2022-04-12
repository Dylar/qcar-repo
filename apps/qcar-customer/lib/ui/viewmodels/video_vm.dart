import 'package:carmanual/core/datasource/SettingsDataSource.dart';
import 'package:carmanual/core/navigation/app_viewmodel.dart';
import 'package:carmanual/models/settings.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:provider/provider.dart';

class VideoViewModelProvider extends ChangeNotifierProvider<VideoProvider> {
  VideoViewModelProvider(SettingsDataSource settingsDataSource)
      : super(create: (_) => VideoProvider(VideoVM(settingsDataSource)));
}

class VideoProvider extends ViewModelProvider<VideoViewModel> {
  VideoProvider(VideoViewModel viewModel) : super(viewModel);
}

abstract class VideoViewModel extends ViewModel {
  String get title;

  VideoInfo? videoInfo;

  Stream<Settings> watchSettings();
}

class VideoVM extends VideoViewModel {
  VideoVM(this.settings);

  SettingsDataSource settings;

  @override
  String get title => videoInfo?.name ?? "";

  @override
  Stream<Settings> watchSettings() {
    return settings.watchSettings();
  }

  @override
  void routingDidPushNext() {
    // _controller.videoPlayerController.pause();
    // _controller.pause();
    super.routingDidPopNext();
  }

  @override
  void routingDidPopNext() {
    // if (VIDEO_SETTINGS["autoPlay"] ?? true) {
    // _controller.videoPlayerController.play();
    // _controller.play();
    // }
    super.routingDidPop();
  }
}
