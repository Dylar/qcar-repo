import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_shared/core/handle_snackbars.dart';

void showNothingToSeeSnackBar(BuildContext context) {
  showSnackBar(context, 'Kommt noch');
}

void showNonOptionalErrorSnackBar(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showSnackBar(context, l10n.formFieldsWrong, duration: 2);
}

void showNoDealerFoundSnackBar(BuildContext context, String name) {
  showSnackBar(context, 'Kein Händler gefunden mit dem Namen $name');
}
