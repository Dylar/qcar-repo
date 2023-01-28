import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/sale_key.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../builder/app_builder.dart';
import '../../../builder/entity_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_getter.dart';
import '../../../utils/test_utils.dart';

Future<AppInfrastructure> createQRInfra({
  List<CarInfo> initialCar = const [],
  List<SaleKey> acceptedKeys = const [],
}) async {
  final cars = [await buildCarInfo(), ...initialCar];
  final sales = [await buildSaleInfo()];
  for (final key in acceptedKeys) {
    final sale = await buildSaleInfo();
    sales.add(sale
      ..key = key.key
      ..brand = key.key
      ..model = key.key);
  }

  return createTestInfra(
    carDataSource: mockCarSource(initialCars: cars),
    saleDataSource: mockSaleSource(initialSaleInfo: sales),
    downloadClient: mockDownloadClient(acceptedKeys: acceptedKeys),
  );
}

Future<AppInfrastructure> pushToQrScan(
  WidgetTester tester, {
  AppInfrastructure? infra,
}) async {
  final testInfra = infra ?? await createQRInfra();
  await pushPage(
    tester,
    routeSpec: QrScanPage.pushIt(),
    wrapWith: (page) => wrapWidget(page, testInfra: testInfra),
  );
  expect(find.byType(QrScanPage), findsOneWidget);
  return testInfra;
}

Future<void> scanOnQRPage(WidgetTester tester, String scan,
    {bool settle = true}) async {
  getQRViewModel().onScan(Barcode(scan, BarcodeFormat.aztec, []));
  if (settle) {
    await tester.pumpAndSettle(Duration(milliseconds: 10));
  } else {
    await tester.pump();
  }
}
