import 'package:flutter/material.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';
import 'package:qcar_customer/ui/notify/info_dialog.dart';

Future openErrorDialog(BuildContext context, String error) {
  return showDialog(
    context: context,
    builder: (context) => InfoDialog(
      title: "ERROR",
      message: error,
      closeButtonText: "Abbrechen",
    ),
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
