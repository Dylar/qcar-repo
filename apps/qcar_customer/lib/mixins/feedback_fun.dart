import 'package:flutter/cupertino.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/notify/dialog.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';
import 'package:qcar_customer/ui/notify/snackbars.dart';

mixin FeedbackFun implements FeedbackViewModel {
  UploadService get uploadService;

  Future Function(Function(BuildContext)) get openDialog;
  Future Function(Function(BuildContext)) get showSnackBar;

  Future sendFeedback(String text) async {
    final response = await uploadService.sendFeedback(text);
    switch (response.status) {
      case ResponseStatus.OK:
        showSnackBar(feedbackSendSnackBar);
        break;
      default:
        openDialog((context) =>
            openErrorDialog(context, response.error ?? "EMPTY ERROR"));
        break;
    }
  }
}
