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
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';

import '../../../builder/app_builder.dart';
import '../../../mocks/test_mock.dart';
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
  testWidgets('App start - none logged in - show login page',
      (WidgetTester tester) async {
    await loadApp(tester);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('App start - all logged in - show home page',
      (WidgetTester tester) async {
    await loadApp(tester, infra: await createTestInfra());
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('App start - only dealer logged in - show Login page',
      (WidgetTester tester) async {
    final infra = await createTestInfra(
      authService: await mockAuthService(
        isDealerLoggedIn: true,
        isUserLoggedIn: false,
      ),
    );

    await loadApp(tester, infra: infra);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('App start - only user logged in - show Login page',
      (WidgetTester tester) async {
    final infra = await createTestInfra(
      authService: await mockAuthService(
        isDealerLoggedIn: false,
        isUserLoggedIn: true,
      ),
    );

    await loadApp(tester, infra: infra);
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
