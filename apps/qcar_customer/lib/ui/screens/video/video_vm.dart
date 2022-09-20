import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

abstract class VideoViewModel extends ViewModel
    implements VideoWidgetViewModel, FeedbackViewModel {
  String get title;

  String get description;

  bool get isFavorite;

  void toggleFavorite();
}

class VideoVM extends VideoViewModel with FeedbackFun {
  VideoVM(
    this.settingsService,
    this.trackingService,
    this.infoService,
    this.videoInfo,
  );

  @override
  TrackingService trackingService;

  @override
  SettingsService settingsService;

  InfoService infoService;

  VideoInfo videoInfo;

  String get title => videoInfo.name;

  String get url => videoInfo.vidUrl;

  String get description => videoInfo.description;

  @override
  bool isFavorite = false;

  @override
  Future init() async {
    super.init();
    isFavorite = await infoService.isFavorite(videoInfo);
    notifyListeners();
  }

  @override
  void toggleFavorite() {
    isFavorite = !isFavorite;
    infoService.toggleFavorite(videoInfo, isFavorite);
    notifyListeners();
  }

  @override
  void onVideoEnd() {}

  @override
  void onVideoStart() {}
}
