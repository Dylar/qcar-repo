import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/ui/app_theme.dart';
import 'package:qcar_customer/ui/widgets/deco.dart';

void showSnackBar(BuildContext context, String text, {int duration = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        height: 48,
        width: double.infinity,
        margin: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
            gradient: qcarGradient),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: BaseColors.primary),
        ),
      ),
      duration: Duration(seconds: duration),
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(0.0),
    ),
  );
}

void showNothingToSeeSnackBar(BuildContext context) {
  showSnackBar(context, 'Kommt noch');
}

void showAlreadyHereSnackBar(BuildContext context) {
  showSnackBar(context, 'Du bist auf dieser Seite');
}

void showSettingsSavedSnackBar(BuildContext context) {
  showSnackBar(context, 'Gespeichert');
}

void updatedSnackBar(BuildContext context) {
  showSnackBar(context, 'Aktualisiert');
}

void feedbackSendSnackBar(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showSnackBar(context, l10n.feedbackThanks, duration: 2);
}

void oldCarScannedSnackBar(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showSnackBar(context, l10n.oldCarScanned, duration: 2);
}
