import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_shared/widgets/confirm_dialog.dart';
import 'package:qcar_shared/widgets/info_dialog.dart';

import '../../../utils/test_l10n.dart';

//TODO put it in shared

void checkSimpleDialog(
  Type type,
  String title,
  String message, {
  bool isVisible = true,
}) {
  final dialog = find.byType(type);
  expect(dialog, isVisible ? findsOneWidget : findsNothing);
  expect(
    find.descendant(of: dialog, matching: find.text(title)),
    isVisible ? findsOneWidget : findsNothing,
  );
  expect(
    find.descendant(of: dialog, matching: find.text(message)),
    isVisible ? findsOneWidget : findsNothing,
  );
}

void checkInfoDialog(
  String title,
  String message, {
  bool isVisible = true,
}) {
  checkSimpleDialog(InfoDialog, title, message, isVisible: isVisible);
}

void checkConfirmDialog(String title, String message) {
  checkSimpleDialog(ConfirmDialog, title, message);
}

void checkErrorDialog(
  TestAppLocalization l10n,
  String error, {
  bool isVisible = true,
}) async {
  checkInfoDialog(l10n.errorTitle, l10n.scanError, isVisible: isVisible);
}
