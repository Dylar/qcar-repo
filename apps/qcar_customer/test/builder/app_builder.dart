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
  final loadClient = mockLoadClient();
  final settingsSource = mockSettings();
  final carSource = mockCarSource();
  final videoSource = mockVideoSource();
  final authService = mockAuthService();
  return AppInfrastructure.load(
    client: loadClient,
    database: db,
    settingsDataSource: settingsSource,
    carInfoDataSource: carSource,
    videoInfoDataSource: videoSource,
    authenticationService: authService,
  );
}
