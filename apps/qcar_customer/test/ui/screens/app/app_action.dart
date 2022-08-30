import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/navigation/app_navigation.dart';

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
