import 'package:carmanual/core/navigation/app_navigation.dart';
import 'package:carmanual/ui/screens/dir/dir_page.dart';
import 'package:carmanual/ui/screens/home/home_page.dart';
import 'package:carmanual/ui/screens/intro/intro_page.dart';
import 'package:carmanual/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:carmanual/ui/widgets/qr_camera_view.dart';
import 'package:carmanual/ui/widgets/video_widget.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_l10n.dart';

void checkIntroPage() {
  expect(find.byType(IntroPage), findsOneWidget);
  expect(find.byType(QRCameraView), findsOneWidget);
}

void checkHomePage() {
  expect(find.byType(HomePage), findsOneWidget);
  expect(find.byType(VideoWidget), findsOneWidget);
}

void checkQRScanPage() {
  expect(find.byType(QrScanPage), findsOneWidget);
  expect(find.byType(QRCameraView), findsOneWidget);
}

void checkDirPage() {
  expect(find.byType(DirPage), findsOneWidget);
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
