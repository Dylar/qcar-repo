import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';

import '../../builder/app_builder.dart';
import '../../utils/test_checker.dart';
import '../../utils/test_navigation.dart';

void main() {
  testWidgets('HomePage - all navigation visible', (WidgetTester tester) async {
    prepareTest();
    await initNavigateToHome(tester);
    checkNavigationBar(HomePage.routeName);
  });
}
