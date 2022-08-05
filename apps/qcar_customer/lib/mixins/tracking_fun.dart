import 'package:qcar_customer/models/Tracking.dart';
import 'package:qcar_customer/service/upload_service.dart';

mixin TrackingFun {
  UploadService get uploadService;

  void sendTracking(String text) {
    uploadService.sendTracking(Tracking(DateTime.now(), text));
  }
}
