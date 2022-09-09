import 'dart:async';

import 'package:qcar_customer/core/misc/helper/logger.dart';
import 'package:qcar_customer/core/service/info_service.dart';
import 'package:qcar_customer/core/service/upload_service.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

abstract class HomeViewModel extends ViewModel
    implements VideoWidgetViewModel, FeedbackViewModel {}

class HomeVM extends HomeViewModel with FeedbackFun {
  HomeVM(this.uploadService, this.infoService);

  @override
  UploadService uploadService;
  final InfoService infoService;

  String url = "";

  @override
  Future init() async {
    url = await infoService.getIntroVideo();
    Logger.logI("Intro: ${url}");
    finishInit();
    notifyListeners();
  }

  @override
  void onVideoEnd() {}

  @override
  void onVideoStart() {}
}
