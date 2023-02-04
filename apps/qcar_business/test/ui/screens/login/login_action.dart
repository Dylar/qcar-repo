import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/ui/screens/app/app.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';

import '../../../builder/app_builder.dart';
import '../../../mocks/network_client_mock.dart';
import '../../../utils/test_utils.dart';
import '../app/app_test.mocks.dart';

Future<AppInfrastructure> createLoginInfra({
  DealerInfo? dealerInfo,
  List<SellerInfo>? sellerInfos,
}) async {
  final client = MockDownloadClient();
  await mockDownloadClient(
    client: client,
    dealerInfo: dealerInfo,
    sellerInfos: sellerInfos,
  );
  return createTestInfra(
    authService: AuthenticationService(),
    downloadClient: client,
  );
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
  expect(find.byType(LoginPage), findsOneWidget);
  return testInfra;
}

Future<void> loginDealer(WidgetTester tester, String name,
    {bool settle = false}) async {
  await tester.enterText(find.byType(TextField), name);
  await tester.pumpAndSettle();
  await tester.tap(find.byType(ElevatedButton));
  settle ? await tester.pumpAndSettle() : await tester.pump();
}
