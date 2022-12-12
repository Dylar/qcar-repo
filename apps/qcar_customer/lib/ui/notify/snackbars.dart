import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_shared/core/handle_snackbars.dart';

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
