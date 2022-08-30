import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';

Future<void> scanOnIntroPage(WidgetTester tester, String scan,
    {bool settle = true}) async {
  final page = find.byType(IntroPage).evaluate().first.widget as IntroPage;
  page.viewModel.onScan(scan);
  if (settle) {
    await tester.pumpAndSettle(Duration(milliseconds: 10));
  } else {
    await tester.pump();
  }
}
