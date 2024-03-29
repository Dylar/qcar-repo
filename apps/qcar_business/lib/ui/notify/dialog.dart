import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/Tracking.dart';
import 'package:qcar_business/core/service/tracking_service.dart';
import 'package:qcar_shared/widgets/confirm_dialog.dart';
import 'package:qcar_shared/widgets/info_dialog.dart';

Future openErrorDialog(BuildContext context, String error) {
  sendTracking(context, TrackType.ERROR, "openErrorDialog: $error");
  return showDialog(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return InfoDialog.asError(
        title: l10n.errorTitle,
        message: error,
        closeButtonText: l10n.ok,
      );
    },
    barrierDismissible: false,
  );
}

Future<bool> openConfirmDialog(
    BuildContext context, String title, String message) async {
  sendTracking(context, TrackType.INFO, "openConfirmDialog: title - message");
  return (await showDialog<bool>(
        context: context,
        builder: (context) => ConfirmDialog(title, message),
        barrierDismissible: false,
      )) ??
      false;
}
