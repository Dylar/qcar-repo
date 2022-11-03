import 'dart:async';

import 'package:qcar_business/core/misc/helper/logger.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/core/service/settings_service.dart';
import 'package:qcar_business/core/service/tracking_service.dart';
import 'package:qcar_business/ui/app_viewmodel.dart';
import 'package:qcar_business/ui/mixins/feedback_fun.dart';
import 'package:qcar_business/ui/widgets/video_widget.dart';

abstract class HomeViewModel extends ViewModel
    implements VideoWidgetViewModel, FeedbackViewModel {}

class HomeVM extends HomeViewModel with FeedbackFun {
  HomeVM(this.settingsService, this.trackingService, this.infoService);

  @override
  TrackingService trackingService;
  final InfoService infoService;

  @override
  SettingsService settingsService;

  String url = "";

  @override
  Future init() async {
    url = await infoService.getIntroVideo();
    Logger.logI("Intro: ${url}");
    notifyListeners();
  }

  @override
  void onVideoEnd() {}

  @override
  void onVideoStart() {}
}
