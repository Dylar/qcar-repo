import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';

import '../../builder/app_builder.dart';
import '../../utils/test_checker.dart';
import '../../utils/test_navigation.dart';

void main() {
  testWidgets('QRScanPage - all navigation visible',
      (WidgetTester tester) async {
    prepareTest();
    await initNavigateToQRScan(tester);
    checkNavigationBar(QrScanPage.routeName);
  });
}
