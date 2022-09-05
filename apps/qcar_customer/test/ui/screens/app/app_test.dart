import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SellInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/service/auth_service.dart';
import 'package:qcar_customer/service/settings_service.dart';
import 'package:qcar_customer/service/upload_service.dart';
import 'package:qcar_customer/ui/screens/cars/categories_page.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/intro/intro_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';

import '../../../builder/app_builder.dart';
import '../../../builder/entity_builder.dart';
import '../../../builder/network_builder.dart';
import '../../../mocks/test_mock.dart';
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
  UploadService,
  HttpClient,
  HttpHeaders,
  HttpClientRequest,
  HttpClientResponse,
])
void main() {
  testWidgets('test navigation', (WidgetTester tester) async {
    final service = mockUploadService(feedbackResponse: okResponse());
    final infra = createTestInfra(uploadService: service);

    //Intro page - scan key
    await loadApp(tester, infra: infra);
    expect(find.byType(IntroPage), findsOneWidget);
    checkSearchIcon(isVisible: false);
    checkReloadIcon(isVisible: false);

    //Home page - looks nice
    final key = await buildSellKey();
    await scanOnIntroPage(tester, key.encode(), settle: false);
    await tester.pump(Duration(milliseconds: 10));
    await tester.pump(Duration(milliseconds: 10));
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
  });
}
