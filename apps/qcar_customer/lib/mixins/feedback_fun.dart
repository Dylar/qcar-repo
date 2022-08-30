import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        openDialog((context) {
          final l10n = AppLocalizations.of(context)!;
          final error = l10n.feedbackError + (response.error ?? "EMPTY ERROR");
          return openErrorDialog(context, error);
        });
        break;
    }
  }
}
