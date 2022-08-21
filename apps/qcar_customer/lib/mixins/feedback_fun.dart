import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';

mixin FeedbackFun implements FeedbackViewModel {
  UploadService get uploadService;

  void sendFeedback(String text) {
    uploadService.sendFeedback(text);
  }
}
