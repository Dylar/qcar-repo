import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/notify/dialog.dart';
import 'package:qcar_customer/ui/notify/snackbars.dart';
import 'package:qcar_shared/network_service.dart';
import 'package:qcar_shared/utils/system_utils.dart' as system;

abstract class FeedbackViewModel {
  void sendFeedback(String text, int rating);

  void sendEmail({String? email});
}

mixin FeedbackFun implements FeedbackViewModel {
  TrackingService get trackingService;

  Future Function(Function(BuildContext)) get openDialog;

  Future Function(Function(BuildContext)) get showSnackBar;

  @override
  Future sendFeedback(String text, int rating) async {
    final response = await trackingService.sendFeedback(text, rating);
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

  @override
  Future sendEmail({String? email}) async {
    await system.sendEmail(email: email);
  }
}
