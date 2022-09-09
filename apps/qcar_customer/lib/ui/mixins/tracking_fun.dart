import 'package:qcar_customer/core/models/Tracking.dart';
import 'package:qcar_customer/core/service/upload_service.dart';

mixin TrackingFun {
  UploadService get uploadService;

  void sendTracking(String text) {
    uploadService.sendTracking(TrackEvent(DateTime.now(), "Navi", text));
  }
}
