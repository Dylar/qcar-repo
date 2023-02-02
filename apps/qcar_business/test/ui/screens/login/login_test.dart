import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';

import 'login_action.dart';

void main() {
  testWidgets('App start - show login page', (WidgetTester tester) async {
    final infra = await pushToLogin(tester);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(await infra.authService.isUserLoggedIn(), isFalse);
    expect(await infra.authService.isDealerLoggedIn(), isFalse);
  });
}
