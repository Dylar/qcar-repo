import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

abstract class VideoViewModel extends ViewModel
    implements VideoWidgetViewModel {
  String get title;
  String get description;
}

class VideoVM extends VideoViewModel with Initializer {
  VideoVM(this.videoInfo);

  VideoInfo? videoInfo;

  String get title => videoInfo?.name ?? "";
  String get url => videoInfo?.vidUrl ?? "";
  String get description => videoInfo?.description ?? "";

  @override
  void init() {
    super.init();
    initializeFinished();
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

  @override
  void onVideoEnd() {}

  @override
  void onVideoStart() {}
}
