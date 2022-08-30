import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/app.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';

import '../../../builder/app_builder.dart';
import '../../../utils/test_utils.dart';

Future<AppInfrastructure> pushToQrScan(
  WidgetTester tester, {
  AppInfrastructure? infra,
}) async {
  final testInfra = infra ?? await createTestInfra();
  await pushPage(
    tester,
    routeSpec: QrScanPage.pushIt(),
    wrapWith: (page) => wrapWidget(page, testInfra: testInfra),
  );
  return testInfra;
}
