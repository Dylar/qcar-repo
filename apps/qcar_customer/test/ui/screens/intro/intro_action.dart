import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../utils/test_getter.dart';

Future<void> scanOnIntroPage(WidgetTester tester, String scan,
    {bool settle = true}) async {
  getIntroViewModel().onScan(Barcode(scan, BarcodeFormat.aztec, []));
  if (settle) {
    await tester.pumpAndSettle(Duration(milliseconds: 10));
  } else {
    await tester.pump();
  }
}
