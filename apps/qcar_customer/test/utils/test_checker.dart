import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/navigation/app_navigation.dart';
import 'package:qcar_customer/ui/screens/categories/categories_page.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qcar_customer/ui/widgets/qr_camera_view.dart';

import 'test_l10n.dart';

void checkIntroPage() {
  expect(find.byType(IntroPage), findsOneWidget);
  expect(find.byType(QRCameraView), findsOneWidget);
}

void checkHomePage() {
  expect(find.byType(HomePage), findsOneWidget);
}

void checkQRScanPage() {
  expect(find.byType(QrScanPage), findsOneWidget);
  expect(find.byType(QRCameraView), findsOneWidget);
}

void checkCategoriesPage() {
  expect(find.byType(CategoriesPage), findsOneWidget);
}

void checkSearchPage(TestAppLocalization l10n) {
  expect(find.text(l10n.searchStartText), findsOneWidget);
}

void checkEmptySearch(TestAppLocalization l10n, {bool isEmpty = true}) {
  expect(
    find.text(l10n.searchEmptyText),
    isEmpty ? findsOneWidget : findsNothing,
  );
}

void checkNavigationBar(String thisPage) {
  final naviFinder = find.byType(AppNavigation);
  expect(naviFinder, findsOneWidget);
  final AppNavigation navi =
      naviFinder.first.evaluate().first.widget as AppNavigation;
  expect(navi.routeName, thisPage);
  naviBarData.forEach((data) {
    expect(
      find.descendant(
        of: naviFinder,
        matching: find.text(data.middleOrThrow),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: naviFinder,
        matching: find.byIcon(data.lastOrThrow),
      ),
      findsOneWidget,
    );
  });
}
