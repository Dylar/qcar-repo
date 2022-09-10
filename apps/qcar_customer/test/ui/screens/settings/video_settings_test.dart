import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';

import '../app/app_checker.dart';
import 'settings_action.dart';

void main() {
  testWidgets('VideoSettingsPage - render', (WidgetTester tester) async {
    await pushToSettings(tester);
    expect(find.byType(SettingsPage), findsOneWidget);
    checkSearchIcon(isVisible: false);
    checkReloadIcon(isVisible: false);
    checkNavigationBar(SettingsPage.routeName);
  });
}
