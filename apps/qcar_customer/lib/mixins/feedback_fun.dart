import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/notify/dialog.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';

mixin FeedbackFun implements FeedbackViewModel {
  UploadService get uploadService;

  Future Function(DialogEvent) get openDialog;

  void sendFeedback(String text) {
    uploadService.sendFeedback(text);
    // openDialog(DialogEvent(DialogType.ERROR)); //TODO feedback from sending
  }
}
