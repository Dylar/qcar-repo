import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/ui/notify/snackbars.dart';
import 'package:qcar_customer/ui/screens/intro/loading_page.dart';

abstract class FeedbackViewModel {
  void sendFeedback(String text);
}

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog(this._viewModel);

  final FeedbackViewModel _viewModel;

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
        title: qcarGradientText(context, l10n.feedbackTitle),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.feedbackHint,
            border: UnderlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.red),
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.green),
            child: Text(l10n.send),
            onPressed: () {
              widget._viewModel.sendFeedback(_controller.text);
              feedbackSendSnackBar(context);
              Navigator.of(context).pop();
            },
          ),
        ]);
  }
}
