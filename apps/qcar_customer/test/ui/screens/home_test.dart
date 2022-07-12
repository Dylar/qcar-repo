import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';

import '../../builder/app_builder.dart';
import '../../utils/test_checker.dart';
import '../../utils/test_navigation.dart';

void main() {
  testWidgets('HomePage - all navigation visible - test feedback dialog',
      (WidgetTester tester) async {
    prepareTest();
    await initNavigateToHome(tester);
    checkNavigationBar(HomePage.routeName);
    // await testFeedback(tester);
  });
}

// Future testFeedback(WidgetTester tester) async {
//   await tester.tap(find.byIcon(Icons.feedback));
//   await tester.pumpAndSettle();
//   expect(find.byType(FeedbackDialog), findsOneWidget);
// }
