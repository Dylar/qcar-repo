import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

import '../../../builder/network_builder.dart';
import '../../../mocks/test_mock.dart';
import '../app/app_checker.dart';
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
    isTest = true;

    testWidgets('QRScanPage - cancel feedback', (WidgetTester tester) async {
      final infra = await pushToQrScan(tester);
      await doCancelFeedback(tester, infra.uploadService);
    });

    testWidgets('QRScanPage - success feedback', (WidgetTester tester) async {
      final infra = await pushToQrScan(tester);
      mockFeedbackResponse(infra.uploadService, okResponse());
      await doSuccessFeedback(tester, infra.uploadService);
    });

    testWidgets('QRScanPage - failed feedback', (WidgetTester tester) async {
      final infra = await pushToQrScan(tester);
      await doFailedFeedback(tester, infra.uploadService);
    });
  });
}
