import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/navigation/navi.dart';

class InfoDialog extends StatelessWidget {
  InfoDialog({
    required this.title,
    required this.message,
    required this.closeButtonText,
  }) : titleColor = BaseColors.veryLightGrey;

  InfoDialog.asError({
    required this.title,
    required this.message,
    required this.closeButtonText,
  }) : titleColor = BaseColors.red;

  final Color titleColor;
  final String title;
  final String message;
  final String closeButtonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title,
            style: Theme.of(context)
                .dialogTheme
                .titleTextStyle!
                .copyWith(color: titleColor)),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.veryLightGrey),
            child: Text(closeButtonText),
            onPressed: () => Navigate.pop(context),
          ),
        ]);
  }
}
