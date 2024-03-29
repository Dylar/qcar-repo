import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

import '../../../builder/network_builder.dart';
import '../../../mocks/test_mock.dart';
import '../app/app_checker.dart';
import '../app/feedback_action.dart';
import 'home_action.dart';

void main() {
  testWidgets('HomePage - render', (WidgetTester tester) async {
    await pushToHome(tester);
    expect(find.byType(HomePage), findsOneWidget);
    checkSearchIcon(isVisible: false);
    checkReloadIcon(isVisible: false);
    checkNavigationBar(HomePage.routeName);

    expect(find.byType(VideoWidget), findsOneWidget);
  });

  group('HomePage - feedback test', () {
    testWidgets('HomePage - cancel feedback', (WidgetTester tester) async {
      final infra = await pushToHome(tester);
      await doCancelFeedback(tester, infra.trackingService);
    });

    testWidgets('HomePage - success feedback', (WidgetTester tester) async {
      final infra = await pushToHome(tester);
      mockFeedbackResponse(infra.trackingService, okResponse());
      await doSuccessFeedback(tester, infra.trackingService, -1);
      await doSuccessFeedback(tester, infra.trackingService, 0);
      await doSuccessFeedback(tester, infra.trackingService, 1);
    });

    testWidgets('HomePage - failed feedback', (WidgetTester tester) async {
      final infra = await pushToHome(tester);
      await doFailedFeedback(tester, infra.trackingService);
    });
  });
}
