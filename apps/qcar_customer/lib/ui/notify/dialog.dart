import 'package:flutter/material.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';

Future openFeedbackDialog(BuildContext context, FeedbackViewModel viewModel) {
  return showDialog(
    context: context,
    builder: (context) => FeedbackDialog(viewModel),
    barrierDismissible: false,
  );
}
