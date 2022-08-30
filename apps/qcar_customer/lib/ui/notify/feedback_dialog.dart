import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
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
        content: Container(
          decoration: BoxDecoration(
            border: Border.all(color: BaseColors.grey),
            color: BaseColors.darkGrey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: _controller,
            autofocus: true,
            maxLines: null,
            decoration: InputDecoration(
              hintText: l10n.feedbackHint, //TODO oder email
              // border: UnderlineInputBorder(),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.red),
            child: Text(l10n.cancel),
            onPressed: () => Navigate.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.green),
            child: Text(l10n.send),
            onPressed: () {
              Navigate.pop(context);
              widget._viewModel.sendFeedback(_controller.text);
            },
          ),
        ]);
  }
}
