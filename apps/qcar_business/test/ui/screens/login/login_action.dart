import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/ui/screens/app/app.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';

import '../../../builder/app_builder.dart';
import '../../../utils/test_utils.dart';

Future<AppInfrastructure> createLoginInfra() async {
  return createTestInfra(authService: AuthenticationService());
}

Future<AppInfrastructure> pushToLogin(
  WidgetTester tester, {
  AppInfrastructure? infra,
}) async {
  final testInfra = infra ?? await createLoginInfra();
  await pushPage(
    tester,
    routeSpec: LoginPage.pushIt(),
    wrapWith: (page) async => await wrapWidget(page, testInfra: testInfra),
  );
  await tester.pumpAndSettle();
  return testInfra;
}
