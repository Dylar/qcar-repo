import 'package:carmanual/core/app.dart';
import 'package:carmanual/ui/screens/dir/dir_page.dart';
import 'package:carmanual/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builder/app_builder.dart';
import '../builder/entity_builder.dart';
import 'test_checker.dart';
import 'test_interactions.dart';

Future<void> loadApp(WidgetTester tester, {AppInfrastructure? infra}) async {
  // Build our app and trigger a frame.
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

  final carsLoaded = await infra.carInfoService.hasCars();
  if (!carsLoaded) {
    final key = await buildSellInfo();
    await infra.carInfoService.onNewScan(key.toJson());
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
