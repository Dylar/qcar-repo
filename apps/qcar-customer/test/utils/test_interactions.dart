// Future<void> swipeNoteToLeft(WidgetTester tester) async {
//   await tester.drag(find.byType(NoteDismissible), const Offset(-500.0, 0.0));
//   await tester.pumpAndSettle();
// }

import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> scanOnIntroPage(WidgetTester tester, String scan,
    {bool settle = true}) async {
  final page = find.byType(IntroPage).evaluate().first.widget as IntroPage;
  page.viewModel.onScan(scan);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

Future<void> tapNaviIcon(WidgetTester tester, String route) async {
  final naviFinder = find.byType(AppNavigation);
  final data =
      naviBarData.firstWhere((data) => data.firstOrThrow.contains(route));

  await tester.tap(find.descendant(
    of: naviFinder,
    matching: find.byIcon(data.lastOrThrow),
  ));
  await tester.pumpAndSettle();
}

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
