import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';

import '../../../builder/entity_builder.dart';
import '../../../utils/test_l10n.dart';
import '../../../utils/test_utils.dart';
import '../app/app_checker.dart';
import '../app/dialog_checker.dart';
import 'intro_action.dart';

void main() {
  testWidgets('Load app - got no cars - show intro screen',
      (WidgetTester tester) async {
    final l10n = await getTestL10n();
    await loadApp(tester);

    checkTrackingDialog(l10n);
    await tester.tap(find.text(l10n.ok));
    await tester.pumpAndSettle();

    expect(find.text(l10n.introPageMessage), findsOneWidget);
    expect(find.byType(IntroPage), findsOneWidget);
    checkSearchIcon(isVisible: false);
    checkReloadIcon(isVisible: false);
  });

  testWidgets('Load app - scan bullshit - show error',
      (WidgetTester tester) async {
    await loadApp(tester);

    final l10n = await getTestL10n();
    await tester.tap(find.text(l10n.ok));
    await tester.pumpAndSettle();

    expect(find.text(l10n.scanError), findsNothing);
    await scanOnIntroPage(tester, "Bullshit");
    expect(find.text(l10n.scanError), findsOneWidget);
  });

  testWidgets('Load app - scan wrong json - show error',
      (WidgetTester tester) async {
    await loadApp(tester);

    final l10n = await getTestL10n();
    await tester.tap(find.text(l10n.ok));
    await tester.pumpAndSettle();

    expect(find.text(l10n.scanError), findsNothing);
    await scanOnIntroPage(tester, "{}");
    expect(find.text(l10n.scanError), findsOneWidget);
  });

  testWidgets('Load app - show intro page - scan key - show home page',
      (WidgetTester tester) async {
    await loadApp(tester);

    final l10n = await getTestL10n();
    await tester.tap(find.text(l10n.ok));
    await tester.pumpAndSettle();

    final key = await buildSellKey();
    final scan = key.encode();
    expect(find.text(l10n.introPageMessage), findsOneWidget);
    expect(find.text(l10n.introPageMessageScanning), findsNothing);
    await scanOnIntroPage(tester, scan, settle: false);
    expect(find.text(l10n.introPageMessage), findsNothing);
    expect(find.text(l10n.introPageMessageScanning), findsOneWidget);
    await tester.pump(Duration(milliseconds: 10));
    await tester.pump(Duration(milliseconds: 10));
    expect(find.byType(HomePage), findsOneWidget);
  });
}
