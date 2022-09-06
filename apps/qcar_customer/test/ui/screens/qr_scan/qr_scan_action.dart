import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/app.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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

Future<void> scanOnQRPage(WidgetTester tester, String scan,
    {bool settle = true}) async {
  final page = find.byType(QrScanPage).evaluate().first.widget as QrScanPage;
  page.viewModel.onScan(Barcode(scan, BarcodeFormat.aztec, []));
  if (settle) {
    await tester.pumpAndSettle(Duration(milliseconds: 10));
  } else {
    await tester.pump();
  }
}
