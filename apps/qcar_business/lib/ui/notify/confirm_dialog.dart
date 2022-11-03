import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/ui/app_theme.dart';
import 'package:qcar_business/ui/navigation/navi.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
    this.title,
    this.message, {
    this.confirmText,
    this.refuseText,
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
            style: TextButton.styleFrom(primary: BaseColors.lightGrey),
            child: Text(refuseText ?? l10n.no),
            onPressed: () => Navigate.pop(context, true),
          ),
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.green),
            child: Text(confirmText ?? l10n.yes),
            onPressed: () => Navigate.pop(context, false),
          ),
        ]);
  }
}
