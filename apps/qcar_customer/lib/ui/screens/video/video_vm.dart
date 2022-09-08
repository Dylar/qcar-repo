import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

abstract class VideoViewModel extends ViewModel
    implements VideoWidgetViewModel, FeedbackViewModel {
  String get title;

  String get description;
}

class VideoVM extends VideoViewModel with FeedbackFun {
  VideoVM(this.uploadService, this.videoInfo);

  @override
  UploadService uploadService;

  VideoInfo? videoInfo;

  String get title => videoInfo?.name ?? "";

  String get url => videoInfo?.vidUrl ?? "";

  String get description => videoInfo?.description ?? "";

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
