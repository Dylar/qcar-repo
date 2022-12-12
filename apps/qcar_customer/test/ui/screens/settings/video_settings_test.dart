import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';
import 'package:qcar_customer/ui/screens/settings/video_settings_page.dart';
import 'package:qcar_shared/widgets/confirm_dialog.dart';

import '../../../utils/test_l10n.dart';
import '../app/app_checker.dart';
import 'settings_action.dart';

void main() {
  testWidgets('VideoSettingsPage - render', (WidgetTester tester) async {
    await pushToVideoSettings(tester);
    final l10n = await getTestL10n();
    expect(find.byType(VideoSettingsPage), findsOneWidget);
    checkSearchIcon(isVisible: false);
    checkReloadIcon(isVisible: false);
    expect(find.text(l10n.save), findsOneWidget);
  });

  testWidgets(
      'VideoSettingsPage - change something - on save -> return to settings page',
      (WidgetTester tester) async {
    await pushToVideoSettings(tester);
    final l10n = await getTestL10n();

    await tester.tap(find.text(l10n.autoPlay));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.save));
    await tester.pumpAndSettle();

    expect(find.byType(VideoSettingsPage), findsNothing);
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets(
      'VideoSettingsPage - change something - on back -> show confirm dialog',
      (WidgetTester tester) async {
    await pushToVideoSettings(tester);
    final l10n = await getTestL10n();

    await tester.tap(find.text(l10n.autoPlay));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(VideoSettingsPage), findsOneWidget);
    expect(find.byType(ConfirmDialog), findsOneWidget);
  });
}
