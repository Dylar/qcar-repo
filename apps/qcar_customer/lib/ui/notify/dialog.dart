import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';
import 'package:qcar_customer/ui/notify/info_dialog.dart';

Future openErrorDialog(BuildContext context, String error) {
  return showDialog(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return InfoDialog.asError(
        title: l10n.errorTitle,
        message: error,
        closeButtonText: l10n.ok,
      );
    },
    barrierDismissible: false,
  );
}

Future openFeedbackDialog(BuildContext context, FeedbackViewModel viewModel) {
  return showDialog(
    context: context,
    builder: (context) => FeedbackDialog(viewModel),
    barrierDismissible: false,
  );
}
