import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/models/sell_key.dart';
import 'package:qcar_customer/ui/screens/cars/cars_list_item.dart';
import 'package:qcar_customer/ui/screens/cars/cars_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';

import '../../../builder/entity_builder.dart';
import '../../../builder/network_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_l10n.dart';
import '../app/app_action.dart';
import '../app/app_checker.dart';
import '../app/dialog_checker.dart';
import '../app/feedback_action.dart';
import 'qr_scan_action.dart';

void main() {
  testWidgets('QRScanPage - render', (WidgetTester tester) async {
    await pushToQrScan(tester);
    expect(find.byType(QrScanPage), findsOneWidget);
    checkSearchIcon(isVisible: false);
    checkReloadIcon(isVisible: false);
  });

  group('QRScanPage - feedback test', () {
    testWidgets('QRScanPage - cancel feedback', (WidgetTester tester) async {
      final infra = await pushToQrScan(tester);
      await doCancelFeedback(tester, infra.trackingService);
    });

    testWidgets('QRScanPage - success feedback', (WidgetTester tester) async {
      final infra = await pushToQrScan(tester);
      mockFeedbackResponse(infra.trackingService, okResponse());
      await doSuccessFeedback(tester, infra.trackingService, -1);
      await doSuccessFeedback(tester, infra.trackingService, 0);
      await doSuccessFeedback(tester, infra.trackingService, 1);
    });

    testWidgets('QRScanPage - failed feedback', (WidgetTester tester) async {
      final infra = await pushToQrScan(tester);
      await doFailedFeedback(tester, infra.trackingService);
    });
  });

  testWidgets('QRScanPage - scan bullshit - show error',
      (WidgetTester tester) async {
    await pushToQrScan(tester);

    final l10n = await getTestL10n();
    checkErrorDialog(l10n, l10n.scanError, isVisible: false);
    await scanOnQRPage(tester, "Bullshit");
    checkErrorDialog(l10n, l10n.scanError);
  });

  testWidgets('QRScanPage - scan wrong json - show error',
      (WidgetTester tester) async {
    await pushToQrScan(tester);

    final l10n = await getTestL10n();
    checkErrorDialog(l10n, l10n.scanError, isVisible: false);
    await scanOnQRPage(tester, "{}");
    checkErrorDialog(l10n, l10n.scanError);
  });

  testWidgets('QRScanPage - scan old key - show error',
      (WidgetTester tester) async {
    final key = await buildSellKey();
    await pushToQrScan(tester);

    final l10n = await getTestL10n();
    expect(find.text(l10n.oldCarScanned), findsNothing);
    await scanOnQRPage(tester, key.encode());
    expect(find.text(l10n.oldCarScanned), findsOneWidget);
  });

  testWidgets('QRScanPage - scan new key - navi to carsPage',
      (WidgetTester tester) async {
    final key = SellKey(key: "newKey");
    final car = await buildCarWith(brand: "hoho", model: "super");
    final infra = await createQRInfra(initialCar: [car], acceptedKeys: [key]);
    await pushToQrScan(tester, infra: infra);

    //navi to cars - show 2 cars
    await tapNaviIcon(tester, CarsPage.routeName);
    expect(find.byType(QrScanPage), findsNothing);
    expect(find.byType(CarsPage), findsOneWidget);
    expect(find.byType(CarInfoListItem), findsNWidgets(2));

    //navi back
    await tapNaviIcon(tester, QrScanPage.routeName);
    await scanOnQRPage(tester, key.encode());

    //navi automatically to cars page - show 3 cars
    expect(find.byType(QrScanPage), findsNothing);
    expect(find.byType(CarsPage), findsOneWidget);
    expect(find.byType(CarInfoListItem), findsNWidgets(3));
  });
}
