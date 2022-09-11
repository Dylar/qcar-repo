import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/notify/confirm_dialog.dart';
import 'package:qcar_customer/ui/notify/info_dialog.dart';

import '../../../utils/test_l10n.dart';

void checkSimpleDialog(Type type, String title, String message) {
  final dialog = find.byType(type);
  expect(dialog, findsOneWidget);
  expect(
    find.descendant(of: dialog, matching: find.text(title)),
    findsOneWidget,
  );
  expect(
    find.descendant(of: dialog, matching: find.text(message)),
    findsOneWidget,
  );
}

void checkInfoDialog(String title, String message) {
  checkSimpleDialog(InfoDialog, title, message);
}

void checkConfirmDialog(String title, String message) {
  checkSimpleDialog(ConfirmDialog, title, message);
}

void checkTrackingDialog(TestAppLocalization l10n) async {
  checkConfirmDialog(l10n.decideTrackingTitle, l10n.decideTrackingMessage);
}
