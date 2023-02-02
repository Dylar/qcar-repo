import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:qcar_business/core/datasource/car_data_source.dart';
import 'package:qcar_business/core/datasource/sale_data_source.dart';
import 'package:qcar_business/core/datasource/settings_data_source.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/settings.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/settings_service.dart';
import 'package:qcar_business/core/service/tracking_service.dart';
import 'package:qcar_shared/network_service.dart';

import '../builder/entity_builder.dart';
import '../ui/screens/app/app_test.mocks.dart';
import 'http_client_mock.dart';

HttpOverrides mockHttpOverrides() => MockHttpOverrides();

UploadClient mockUploadClient() {
  return MockUploadClient();
}

DownloadClient mockDownloadClient() {
  final client = MockDownloadClient();
  // when(client.loadCarInfo(any)).thenAnswer((inv) async {
  //   final info = inv.positionalArguments[0] as SaleInfo;
  //   final car = await buildCarWith(brand: info.brand, model: info.model);
  //   return Response.ok(json: jsonEncode(car.toMap()));
  // });
  //
  // when(client.loadSaleInfo(any)).thenAnswer((inv) async {
  //   final saleKey = inv.positionalArguments[0] as SaleKey;
  //   final key = saleKey.key;
  //   final saleInfo = await buildSaleInfo();
  //   if (saleInfo.key == key) {
  //     return Response.ok(json: jsonEncode(saleInfo.toMap()));
  //   }
  //   if (acceptedKeys.any((k) => k.key == key)) {
  //     saleInfo
  //       ..brand = key
  //       ..model = key;
  //     return Response.ok(json: jsonEncode(saleInfo.toMap()));
  //   }
  //   throw Exception("WRONG KEY");
  // });
  //
  // when(client.progressValue).thenReturn(ValueNotifier(Tuple(1, 1)));
  return client;
}

SettingsDataSource mockSettings() {
  final source = MockSettingsDataSource();
  Settings settings = Settings();
  when(source.getSettings()).thenAnswer((_) async => settings);
  when(source.watchSettings()).thenAnswer((_) async* {
    yield settings;
  });
  when(source.saveSettings(settings)).thenAnswer((inv) async {
    settings = inv.positionalArguments.first;
    return true;
  });
  return source;
}

CarInfoDataSource mockCarSource({List<CarInfo>? initialCars}) {
  final source = MockCarInfoDataSource();
  final cars = initialCars ?? [];
  when(source.getAllCars()).thenAnswer((_) async => cars);
  when(source.watchCarInfo()).thenAnswer((_) async* {
    yield cars;
  });
  when(source.addCarInfo(any)).thenAnswer((inv) async {
    final car = inv.positionalArguments.first;
    if (!cars.any((e) => e.brand == car.brand && e.model == car.model)) {
      cars.add(car);
    }
  });
  return source;
}

SaleInfoDataSource mockSaleSource({List<SaleInfo>? initialSaleInfo}) {
  final source = MockSaleInfoDataSource();
  // final sales = initialSaleInfo ?? [];
  // when(source.getAllSaleInfos()).thenAnswer((_) async => sales);
  // when(source.addSaleInfo(any)).thenAnswer((inv) async {
  //   final info = inv.positionalArguments.first;
  //   if (!sales.any((e) => e.brand == info.brand && e.model == info.model)) {
  //     sales.add(info);
  //   }
  // });
  return source;
}

Future<AuthenticationService> mockAuthService({
  bool isDealerLoggedIn = true,
  bool isUserLoggedIn = true,
}) async {
  final dealer = await buildDealerInfo();
  final seller = await buildSellerInfo();
  final service = MockAuthenticationService();
  when(service.isDealerLoggedIn()).thenAnswer((inv) async => isDealerLoggedIn);
  when(service.currentDealer).thenAnswer((inv) => dealer);
  when(service.isUserLoggedIn()).thenAnswer((inv) async => isUserLoggedIn);
  when(service.currentSeller).thenAnswer((inv) => seller);
  return service;
}

TrackingService mockTrackingService({
  Response? trackingResponse,
}) {
  final service = MockTrackingService();
  if (trackingResponse != null) {
    when(service.sendTracking(any, any))
        .thenAnswer((inv) async => trackingResponse);
  }
  return service;
}

SettingsService mockSettingsService() {
  return MockSettingsService();
}
