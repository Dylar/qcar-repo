import 'package:flutter/material.dart';
import 'package:qcar_shared/core/handle_snackbars.dart';

void showNothingToSeeSnackBar(BuildContext context) {
  showSnackBar(context, 'Kommt noch');
}

void showNonOptionalErrorSnackBar(BuildContext context) {
  showSnackBar(context, 'Es sind nicht alle Felder ausgefüllt', duration: 2);
}
