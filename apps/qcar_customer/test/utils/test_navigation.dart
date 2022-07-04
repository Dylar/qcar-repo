import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/app.dart';
import 'package:qcar_customer/ui/screens/dir/dir_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';

import '../builder/app_builder.dart';
import '../builder/entity_builder.dart';
import 'test_checker.dart';
import 'test_interactions.dart';

Future<void> loadApp(WidgetTester tester, {AppInfrastructure? infra}) async {
  // Build our app and trigger some frames.
  final appWidget = await buildTestApp(infra: infra);
  await tester.pumpWidget(appWidget);
  for (int i = 0; i < 5; i++) {
    await tester.pump(Duration(seconds: 1));
  }
}

Future<void> initNavigateToIntro(WidgetTester tester,
    {AppInfrastructure? infra}) async {
  await loadApp(tester, infra: infra);
  checkIntroPage();
}

Future<void> initNavigateToHome(WidgetTester tester,
    {AppInfrastructure? infra}) async {
  infra ??= defaultTestInfra();

  final carsLoaded = await infra.infoService.hasCars();
  if (!carsLoaded) {
    final key = await buildSellKey();
    await infra.infoService.onNewScan(key.encode());
  }
  await loadApp(tester, infra: infra);
  checkHomePage();
}

Future<void> initNavigateToQRScan(WidgetTester tester,
    {AppInfrastructure? infra}) async {
  await initNavigateToHome(tester, infra: infra);
  await tapNaviIcon(tester, QrScanPage.routeName);
  checkQRScanPage();
}

Future<void> initNavigateToDir(WidgetTester tester,
    {AppInfrastructure? infra}) async {
  await initNavigateToHome(tester, infra: infra);
  await tapNaviIcon(tester, DirPage.routeName);
  checkDirPage();
}
