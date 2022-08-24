import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';

import '../../builder/app_builder.dart';
import '../../utils/test_checker.dart';
import '../../utils/test_l10n.dart';
import '../../utils/test_navigation.dart';

void main() {
  testWidgets('HomePage - all navigation visible - test feedback dialog',
      (WidgetTester tester) async {
    prepareTest();
    final infra = defaultTestInfra();
    await initNavigateToHome(tester, infra: infra);
    checkNavigationBar(HomePage.routeName);
    await testFeedback(tester, infra.uploadService);
  });
}

Future testFeedback(
  WidgetTester tester,
  UploadService trackingService,
) async {
  final feedbackTextField = find.descendant(
    of: find.byType(FeedbackDialog),
    matching: find.byType(TextField),
  );

  final l10n = await getTestL10n();

  await tester.tap(find.byIcon(Icons.feedback));
  await tester.pump();
  expect(find.byType(FeedbackDialog), findsOneWidget);
  final noFeedbackText = "Ich geb doch kein Feedback";
  await tester.enterText(feedbackTextField, noFeedbackText);

  await tester.tap(find.text(l10n.cancel));
  await tester.pump();

  expect(find.text(l10n.feedbackThanks), findsNothing);
  expect(find.byType(FeedbackDialog), findsNothing);
  verifyNever(trackingService.sendFeedback(any));

  await tester.tap(find.byIcon(Icons.feedback));
  await tester.pump();
  expect(find.byType(FeedbackDialog), findsOneWidget);
  final feedbackText = "Hallo das is mein feedback";
  await tester.enterText(feedbackTextField, feedbackText);

  await tester.tap(find.text(l10n.send));
  await tester.pump();

  expect(find.text(l10n.feedbackThanks), findsOneWidget);
  expect(find.byType(FeedbackDialog), findsNothing);
  var result = verify(trackingService.sendFeedback(captureAny));
  expect((result.captured.single as String), feedbackText);
}
