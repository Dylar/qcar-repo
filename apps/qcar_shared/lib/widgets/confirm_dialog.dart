import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_theme.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
    this.title,
    this.message, {
    this.confirmText,
    this.refuseText,
    super.key,
  });

  final String title;
  final String message;
  final String? confirmText;
  final String? refuseText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(foregroundColor: BaseColors.lightGrey),
            child: Text(refuseText ?? l10n.no),
            onPressed: () => Navigate.pop(context, true),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: BaseColors.green),
            child: Text(confirmText ?? l10n.yes),
            onPressed: () => Navigate.pop(context, false),
          ),
        ]);
  }
}
