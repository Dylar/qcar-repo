import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SellInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/service/auth_service.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/screens/cars/categories_page.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';

import '../../../builder/entity_builder.dart';
import '../../../utils/test_l10n.dart';
import '../../../utils/test_utils.dart';
import '../intro/intro_action.dart';
import 'app_action.dart';
import 'app_checker.dart';

@GenerateMocks([
  DownloadClient,
  UploadClient,
  AppDatabase,
  SettingsDataSource,
  SettingsService,
  CarInfoDataSource,
  SellInfoDataSource,
  AuthenticationService,
  TrackingService,
  HttpClient,
  HttpHeaders,
  HttpClientRequest,
  HttpClientResponse,
])
void main() {
  testWidgets('test navigation', (WidgetTester tester) async {
    await loadApp(tester);
    final l10n = await getTestL10n();

    //Intro page
    expect(find.byType(IntroPage), findsOneWidget);

    //accept tracking dialog
    await tester.tap(find.text(l10n.ok));
    await tester.pumpAndSettle();

    //scan key
    final key = await buildSellKey();
    await scanOnIntroPage(tester, key.encode(), settle: false);
    await tester.pump(Duration(milliseconds: 10));
    await tester.pump(Duration(milliseconds: 10));

    //Home page - looks nice
    expect(find.byType(HomePage), findsOneWidget);
    checkNavigationBar(HomePage.routeName);

    //qr scan page - fine fine
    await tapNaviIcon(tester, QrScanPage.routeName);
    expect(find.byType(QrScanPage), findsOneWidget);
    checkNavigationBar(QrScanPage.routeName);

    //car page - nice car
    await tapNaviIcon(tester, CategoriesPage.routeName);
    expect(find.byType(CategoriesPage), findsOneWidget);
    checkNavigationBar(CategoriesPage.routeName);

    //settings page - aaahh die settings
    await tapNaviIcon(tester, SettingsPage.routeName);
    expect(find.byType(SettingsPage), findsOneWidget);
    checkNavigationBar(SettingsPage.routeName);
  });
}
