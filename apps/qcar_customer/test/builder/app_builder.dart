import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:qcar_customer/core/app.dart';

import '../mocks/path_provider_mock.dart';
import '../mocks/test_mock.dart';
import '../ui/screens/intro_test.mocks.dart';

Future<App> buildTestApp({AppInfrastructure? infra}) async {
  infra ??= defaultTestInfra();
  return App(infrastructure: infra);
}

Future<void> prepareTest() async {
  HttpOverrides.global = mockHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('test/.testEnv').readAsStringSync());
  PathProviderPlatform.instance = FakePathProviderPlatform();
}

AppInfrastructure defaultTestInfra() {
  final db = MockAppDatabase();
  final downloadClient = mockDownloadClient();
  final uploadClient = mockUploadClient();
  final settingsSource = mockSettings();
  final carSource = mockCarSource();
  final sellSource = mockSellSource();
  final authService = mockAuthService();
  final trackService = mockUploadService();
  final settingsService = mockSettingsService();
  return AppInfrastructure.load(
    settingsService,
    downloadClient: downloadClient,
    uploadClient: uploadClient,
    database: db,
    settingsDataSource: settingsSource,
    carInfoDataSource: carSource,
    sellInfoDataSource: sellSource,
    authenticationService: authService,
    uploadService: trackService,
  );
}
