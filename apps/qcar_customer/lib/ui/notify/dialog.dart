import 'package:flutter/material.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';
import 'package:qcar_customer/ui/notify/info_dialog.dart';

enum DialogType { ERROR }

class DialogEvent {
  DialogEvent(this.type);

  final DialogType type;
}

Future openDialog(BuildContext context, DialogEvent event) async {
  print("OpenDialog");
  return openErrorDialog(context);
}

Future openErrorDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => InfoDialog(
      title: "ERROR",
      message: "Tja das lief schief",
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
