import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:qcar_business/core/datasource/car_data_source.dart';
import 'package:qcar_business/core/datasource/database.dart';
import 'package:qcar_business/core/datasource/sale_data_source.dart';
import 'package:qcar_business/core/datasource/settings_data_source.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/settings_service.dart';
import 'package:qcar_business/core/service/tracking_service.dart';

import '../../../utils/test_l10n.dart';
import '../../../utils/test_utils.dart';

@GenerateMocks([
  DownloadClient,
  UploadClient,
  AppDatabase,
  SettingsDataSource,
  SettingsService,
  CarInfoDataSource,
  SaleInfoDataSource,
  AuthenticationService,
  TrackingService,
  HttpClient,
  HttpHeaders,
  HttpClientRequest,
  HttpClientResponse,
])
void main() {
  // TODO make general test? or app start blubb
  testWidgets('test what ever', (WidgetTester tester) async {
    await loadApp(tester);
    final l10n = await getTestL10n();

    // //Intro page
    // expect(find.byType(IntroPage), findsOneWidget);
    //
    // //accept tracking dialog
    // await tester.tap(find.text(l10n.ok));
    // await tester.pumpAndSettle();
    //
    // //scan key
    // final key = await buildSaleKey();
    // await scanOnIntroPage(tester, key.encode(), settle: false);
    // await tester.pump(Duration(milliseconds: 10));
    // await tester.pump(Duration(milliseconds: 10));
    //
    // //Home page - looks nice
    // expect(find.byType(HomePage), findsOneWidget);
    // checkNavigationBar(HomePage.routeName);
    //
    // //qr scan page - fine fine
    // await tapNaviIcon(tester, QrScanPage.routeName);
    // expect(find.byType(QrScanPage), findsOneWidget);
    // checkNavigationBar(QrScanPage.routeName);
    //
    // //car page - nice car
    // await tapNaviIcon(tester, CategoriesPage.routeName);
    // expect(find.byType(CategoriesPage), findsOneWidget);
    // checkNavigationBar(CategoriesPage.routeName);
    //
    // //settings page - aaahh die settings
    // await tapNaviIcon(tester, SettingsPage.routeName);
    // expect(find.byType(SettingsPage), findsOneWidget);
    // checkNavigationBar(SettingsPage.routeName);
  });
}
