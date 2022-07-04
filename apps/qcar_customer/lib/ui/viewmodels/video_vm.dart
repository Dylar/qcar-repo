import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/settings.dart';
import 'package:qcar_customer/models/video_info.dart';

abstract class VideoViewModel extends ViewModel {
  VideoInfo? videoInfo;

  late String title;

  Stream<Settings> watchSettings();
}

class VideoVM extends VideoViewModel {
  VideoVM(this.settings, VideoInfo info) {
    this.videoInfo = info;
  }

  SettingsDataSource settings;

  String get title => videoInfo?.name ?? "";

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
