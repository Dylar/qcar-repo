import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/notify/info_dialog.dart';

void checkInfoDialog(String title, String message) {
  final dialog = find.byType(InfoDialog);
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
