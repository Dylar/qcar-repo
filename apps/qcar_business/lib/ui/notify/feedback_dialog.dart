import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/ui/mixins/feedback_fun.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/widgets/deco.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog(this._viewModel);

  final FeedbackViewModel _viewModel;

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  late TextEditingController _controller;

  int _rating = 0;

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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                    hintText: l10n.feedbackHint,
                    // border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Oder senden Sie uns ',
                        style: TextStyle(
                            color: Colors.white), //TODO color intro theme
                      ),
                      TextSpan(
                        text: 'eine Email',
                        style: TextStyle(color: Colors.lightBlue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async => widget._viewModel.sendEmail(),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: InkWell(
                      child: Icon(_rating == -1
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined),
                      onTap: () => setState(() => _rating = -1),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      child: Icon(
                          _rating == 0 ? Icons.circle : Icons.circle_outlined),
                      onTap: () => setState(() => _rating = 0),
                    ),
                  ),
                  Container(
                    child: InkWell(
                      child: Icon(_rating == 1
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined),
                      onTap: () => setState(() => _rating = 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(foregroundColor: BaseColors.lightGrey),
            child: Text(l10n.cancel),
            onPressed: () => Navigate.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: BaseColors.green),
            child: Text(l10n.send),
            onPressed: () {
              Navigate.pop(context);
              widget._viewModel.sendFeedback(_controller.text, _rating);
            },
          ),
        ]);
  }
}
