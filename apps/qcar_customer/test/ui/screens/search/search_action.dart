import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> tapOnSearch(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.search));
  await tester.pumpAndSettle();
}

Future<void> performSearch(WidgetTester tester, String query) async {
  final searchField = find.byType(TextField);
  await tester.enterText(searchField, query);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle(const Duration(milliseconds: 10));
}
