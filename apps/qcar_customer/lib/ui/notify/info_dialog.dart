import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    required this.title,
    required this.message,
    required this.closeButtonText,
  });

  final String title;
  final String message;
  final String closeButtonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.primary),
            child: Text(closeButtonText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]);
  }
}
