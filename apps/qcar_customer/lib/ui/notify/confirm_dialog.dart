import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/ui/app_theme.dart';
import 'package:qcar_customer/ui/navigation/navi.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(this.title, this.message);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.lightGrey),
            child: Text(l10n.no),
            onPressed: () => Navigate.pop(context, true),
          ),
          TextButton(
            style: TextButton.styleFrom(primary: BaseColors.green),
            child: Text(l10n.yes),
            onPressed: () => Navigate.pop(context, false),
          ),
        ]);
  }
}
