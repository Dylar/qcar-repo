import 'dart:async';

import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/service/feedback_fun.dart';
import 'package:qcar_customer/service/info_service.dart';
import 'package:qcar_customer/service/tracking_service.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

import '../../core/tracking.dart';

abstract class HomeViewModel extends ViewModel
    with FeedbackFun
    implements VideoWidgetViewModel {}

class HomeVM extends HomeViewModel with Initializer {
  HomeVM(this.trackingService, this.infoService);

  @override
  TrackingService trackingService;
  final InfoService infoService;

  String url = "";

  @override
  void init() {
    super.init();
    initVideo();
  }

  Future<void> initVideo() async {
    url = await infoService.getIntroVideo();
    Logger.logI("Intro: ${url}");
    initializeFinished();
    notifyListeners();
  }

  @override
  void onVideoEnd() {}

  @override
  void onVideoStart() {}
}
