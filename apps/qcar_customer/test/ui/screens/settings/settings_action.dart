import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';

import '../../../builder/app_builder.dart';
import '../../../builder/entity_builder.dart';
import '../../../mocks/test_mock.dart';
import '../../../utils/test_l10n.dart';
import '../../../utils/test_utils.dart';

Future<AppInfrastructure> createSettingsInfra() async {
  final car = await buildCarInfo();
  final sale = await buildSaleInfo();
  return createTestInfra(
    carDataSource: mockCarSource(initialCars: [car]),
    saleDataSource: mockSaleSource(initialSaleInfo: [sale]),
  );
}

Future<AppInfrastructure> pushToSettings(
  WidgetTester tester, {
  AppInfrastructure? infra,
}) async {
  final testInfra = infra ?? await createSettingsInfra();
  await pushPage(
    tester,
    routeSpec: SettingsPage.pushIt(),
    wrapWith: (page) => wrapWidget(page, testInfra: testInfra),
  );
  await tester.pumpAndSettle();
  return testInfra;
}

Future<AppInfrastructure> pushToVideoSettings(
  WidgetTester tester, {
  AppInfrastructure? infra,
}) async {
  final struct = await pushToSettings(tester, infra: infra);
  final l10n = await getTestL10n();
  await tester.tap(find.text(l10n.videoMenu));
  await tester.pumpAndSettle();
  return struct;
}

Future tapTitle(
  WidgetTester tester,
  TestAppLocalization l10n, {
  int times = 1,
}) async {
  for (int i = 0; i < times; i++) {
    await tester.tap(find.text(l10n.settingsPageTitle));
    await tester.pumpAndSettle();
  }
  await tester.longPress(find.text(l10n.settingsPageTitle));
  await tester.pumpAndSettle();
}
