import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qcar_customer/core/service/upload_service.dart';
import 'package:qcar_customer/ui/notify/feedback_dialog.dart';

import '../../../builder/network_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_l10n.dart';
import 'dialog_checker.dart';

Future doCancelFeedback(
  WidgetTester tester,
  UploadService trackingService,
) async {
  final l10n = await getTestL10n();
  final feedbackTextField = find.descendant(
    of: find.byType(FeedbackDialog),
    matching: find.byType(TextField),
  );

  await tester.tap(find.byIcon(Icons.feedback));
  await tester.pump(Duration(milliseconds: 10));
  expect(find.byType(FeedbackDialog), findsOneWidget);
  final noFeedbackText = "Ich geb doch kein Feedback";
  await tester.enterText(feedbackTextField, noFeedbackText);

  await tester.tap(find.text(l10n.cancel));
  await tester.pump(Duration(milliseconds: 10));

  expect(find.text(l10n.feedbackThanks), findsNothing);
  expect(find.byType(FeedbackDialog), findsNothing);
  verifyNever(trackingService.sendFeedback(any));
}

Future doSuccessFeedback(
  WidgetTester tester,
  UploadService trackingService,
) async {
  final l10n = await getTestL10n();
  final feedbackTextField = find.descendant(
    of: find.byType(FeedbackDialog),
    matching: find.byType(TextField),
  );

  await tester.tap(find.byIcon(Icons.feedback));
  await tester.pump(Duration(milliseconds: 10));
  expect(find.byType(FeedbackDialog), findsOneWidget);
  final feedbackText = "Hallo das is mein feedback";
  await tester.enterText(feedbackTextField, feedbackText);

  await tester.tap(find.text(l10n.send));
  await tester.pump(Duration(milliseconds: 10));

  expect(find.text(l10n.feedbackThanks), findsOneWidget);
  expect(find.byType(FeedbackDialog), findsNothing);
  var result = verify(trackingService.sendFeedback(captureAny));
  expect((result.captured.single as String), feedbackText);
}

Future doFailedFeedback(
  WidgetTester tester,
  UploadService trackingService,
) async {
  final errorText = "ERROR IS DAS";
  mockFeedbackResponse(trackingService, errorResponse(errorText));

  final l10n = await getTestL10n();
  final feedbackTextField = find.descendant(
    of: find.byType(FeedbackDialog),
    matching: find.byType(TextField),
  );

  await tester.tap(find.byIcon(Icons.feedback));
  await tester.pump(Duration(milliseconds: 10));
  expect(find.byType(FeedbackDialog), findsOneWidget);
  final feedbackText = "Hallo das is mein feedback";
  await tester.enterText(feedbackTextField, feedbackText);

  await tester.tap(find.text(l10n.send));
  await tester.pump(Duration(milliseconds: 10));
  await tester.pump(Duration(milliseconds: 10));
  await tester.pump(Duration(milliseconds: 10));

  expect(find.text(l10n.feedbackThanks), findsNothing);
  expect(find.byType(FeedbackDialog), findsNothing);
  var result = verify(trackingService.sendFeedback(captureAny));
  expect((result.captured.single as String), feedbackText);

  checkInfoDialog(l10n.errorTitle, l10n.feedbackError + errorText);
}
