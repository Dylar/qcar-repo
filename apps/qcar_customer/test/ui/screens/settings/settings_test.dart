import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/settings/debug_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';
import 'package:qcar_customer/ui/screens/settings/video_settings_page.dart';

import '../../../builder/network_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_l10n.dart';
import '../app/app_checker.dart';
import '../app/feedback_action.dart';
import 'settings_action.dart';

void main() {
  testWidgets('SettingsPage - render', (WidgetTester tester) async {
    await pushToSettings(tester);
    expect(find.byType(SettingsPage), findsOneWidget);
    checkSearchIcon(isVisible: false);
    checkReloadIcon(isVisible: false);
    checkNavigationBar(SettingsPage.routeName);
  });

  group('SettingsPage - feedback test', () {
    testWidgets('SettingsPage - cancel feedback', (WidgetTester tester) async {
      final infra = await pushToSettings(tester);
      await doCancelFeedback(tester, infra.uploadService);
    });

    testWidgets('SettingsPage - success feedback', (WidgetTester tester) async {
      final infra = await pushToSettings(tester);
      mockFeedbackResponse(infra.uploadService, okResponse());
      await doSuccessFeedback(tester, infra.uploadService);
    });

    testWidgets('SettingsPage - failed feedback', (WidgetTester tester) async {
      final infra = await pushToSettings(tester);
      await doFailedFeedback(tester, infra.uploadService);
    });
  });

  group('SettingsPage - navigate', () {
    testWidgets('SettingsPage - navi to debug', (WidgetTester tester) async {
      await pushToSettings(tester);
      final l10n = await getTestL10n();

      await tapTitle(tester, l10n, times: 3);

      await tester.tap(find.text(l10n.debugMenu));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsNothing);
      expect(find.byType(DebugPage), findsOneWidget);
    });

    testWidgets('SettingsPage - navi to video settings',
        (WidgetTester tester) async {
      await pushToSettings(tester);
      final l10n = await getTestL10n();

      await tester.tap(find.text(l10n.videoMenu));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsNothing);
      expect(find.byType(VideoSettingsPage), findsOneWidget);
    });
  });

  testWidgets('SettingsPage - show about dialog', (WidgetTester tester) async {
    await pushToSettings(tester);
    final l10n = await getTestL10n();

    expect(find.byType(AboutDialog), findsNothing);
    await tester.tap(find.text(l10n.aboutDialog));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.byType(AboutDialog), findsOneWidget);
  });

  testWidgets('SettingsPage - show debug menu', (WidgetTester tester) async {
    await pushToSettings(tester);
    final l10n = await getTestL10n();

    await tapTitle(tester, l10n, times: 2);
    expect(find.text(l10n.debugMenu), findsNothing);

    await tapTitle(tester, l10n, times: 4);
    expect(find.text(l10n.debugMenu), findsNothing);

    await tapTitle(tester, l10n, times: 3);
    expect(find.text(l10n.debugMenu), findsOneWidget);

    await tapTitle(tester, l10n, times: 3);
    expect(find.text(l10n.debugMenu), findsNothing);
  });
}
