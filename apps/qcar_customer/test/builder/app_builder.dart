import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:qcar_customer/core/datasource/car_data_source.dart';
import 'package:qcar_customer/core/datasource/favorite_data_source.dart';
import 'package:qcar_customer/core/datasource/sale_data_source.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_customer/ui/screens/app/app.dart';

import '../mocks/path_provider_mock.dart';
import '../mocks/test_mock.dart';
import '../ui/screens/app/app_test.mocks.dart';

Future<void> prepareTest() async {
  HttpOverrides.global = mockHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(fileInput: File('test/.testEnv').readAsStringSync());
  PathProviderPlatform.instance = FakePathProviderPlatform();
}

AppInfrastructure createTestInfra({
  DownloadClient? downloadClient,
  TrackingService? trackingService,
  SaleInfoDataSource? saleDataSource,
  CarInfoDataSource? carDataSource,
  FavoriteDataSource? favoriteDataSource,
}) {
  final db = MockAppDatabase();
  final dlClient = downloadClient ?? mockDownloadClient();
  final uploadClient = mockUploadClient();
  final settingsSource = mockSettings();
  final carSource = carDataSource ?? mockCarSource();
  final saleSource = saleDataSource ?? mockSaleSource();
  final authService = mockAuthService();
  final trackService = trackingService ?? mockTrackingService();
  final favDataSource = favoriteDataSource ?? mockFavoriteSource();
  return AppInfrastructure.load(
    downloadClient: dlClient,
    uploadClient: uploadClient,
    database: db,
    settingsDataSource: settingsSource,
    carInfoDataSource: carSource,
    favoriteDataSource: favDataSource,
    saleInfoDataSource: saleSource,
    authenticationService: authService,
    trackingService: trackService,
  );
}
