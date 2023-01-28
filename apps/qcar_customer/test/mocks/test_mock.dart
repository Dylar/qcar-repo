import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:qcar_customer/core/datasource/car_data_source.dart';
import 'package:qcar_customer/core/datasource/favorite_data_source.dart';
import 'package:qcar_customer/core/datasource/sale_data_source.dart';
import 'package:qcar_customer/core/datasource/settings_data_source.dart';
import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/favorite.dart';
import 'package:qcar_customer/core/models/sale_info.dart';
import 'package:qcar_customer/core/models/sale_key.dart';
import 'package:qcar_customer/core/models/settings.dart';
import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/service/auth_service.dart';
import 'package:qcar_customer/core/service/settings_service.dart';
import 'package:qcar_customer/core/service/tracking_service.dart';
import 'package:qcar_shared/network_service.dart';
import 'package:qcar_shared/tuple.dart';

import '../builder/entity_builder.dart';
import '../ui/screens/app/app_test.mocks.dart';
import 'http_client_mock.dart';

HttpOverrides mockHttpOverrides() => MockHttpOverrides();

UploadClient mockUploadClient() {
  return MockUploadClient();
}

DownloadClient mockDownloadClient({List<SaleKey> acceptedKeys = const []}) {
  final client = MockDownloadClient();
  when(client.loadCarInfo(any)).thenAnswer((inv) async {
    final info = inv.positionalArguments[0] as SaleInfo;
    final car = await buildCarWith(brand: info.brand, model: info.model);

    //TODO maybe delete me if we got the urls right
    car.categories.forEach((category) {
      category.videos.forEach((vid) {
        vid.brand = car.brand;
        vid.model = car.model;
      });
    });
    return Response.ok(json: jsonEncode(car.toMap()));
  });

  when(client.loadSaleInfo(any)).thenAnswer((inv) async {
    final saleKey = inv.positionalArguments[0] as SaleKey;
    final key = saleKey.key;
    final saleInfo = await buildSaleInfo();
    if (saleInfo.key == key) {
      return Response.ok(json: jsonEncode(saleInfo.toMap()));
    }
    if (acceptedKeys.any((k) => k.key == key)) {
      saleInfo
        ..brand = key
        ..model = key;
      return Response.ok(json: jsonEncode(saleInfo.toMap()));
    }
    throw Exception("WRONG KEY");
  });

  when(client.progressValue).thenReturn(ValueNotifier(Tuple(1, 1)));
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

  when(source.findVideos(any)).thenAnswer((inv) async {
    final lowerQuery = inv.positionalArguments.first.toLowerCase();
    final vids = <VideoInfo>[];
    cars.first.categories.forEach((cat) {
      if (cat.name.toLowerCase().contains(lowerQuery)) {
        vids.addAll(cat.videos);
      } else {
        cat.videos.forEach((vid) {
          final found = vid.name.toLowerCase().contains(lowerQuery) ||
              vid.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
          if (found) {
            vids.add(vid);
          }
        });
      }
    });
    return vids;
  });
  return source;
}

SaleInfoDataSource mockSaleSource({List<SaleInfo>? initialSaleInfo}) {
  final source = MockSaleInfoDataSource();
  final sales = initialSaleInfo ?? [];
  when(source.getAllSaleInfos()).thenAnswer((_) async => sales);
  when(source.addSaleInfo(any)).thenAnswer((inv) async {
    final info = inv.positionalArguments.first;
    if (!sales.any((e) => e.brand == info.brand && e.model == info.model)) {
      sales.add(info);
    }
  });
  return source;
}

FavoriteDataSource mockFavoriteSource({List<Favorite>? initialFavorites}) {
  final favs = initialFavorites ?? [];
  final source = MockFavoriteDataSource();
  when(source.watchFavorites()).thenAnswer((_) async* {
    yield favs;
  });
  when(source.getFavorites(any, any)).thenAnswer((inv) async {
    final brand = inv.positionalArguments[0];
    final model = inv.positionalArguments[1];
    return favs
        .where((fav) => fav.brand == brand && fav.model == model)
        .toList();
  });
  when(source.getFavorite(any, any, any, any)).thenAnswer((inv) async {
    final brand = inv.positionalArguments[0];
    final model = inv.positionalArguments[1];
    final cat = inv.positionalArguments[2];
    final vid = inv.positionalArguments[3];
    return favs.firstWhere((fav) =>
        fav.brand == brand &&
        fav.model == model &&
        fav.category == cat &&
        fav.video == vid);
  });

  return source;
}

AuthenticationService mockAuthService({bool isLoggedIn = true}) {
  final service = MockAuthenticationService();
  when(service.signInAnon()).thenAnswer((inv) async => isLoggedIn);
  return service;
}

TrackingService mockTrackingService({
  Response? feedbackResponse,
  Response? trackingResponse,
}) {
  final service = MockTrackingService();
  if (feedbackResponse != null) {
    when(service.sendFeedback(any, any))
        .thenAnswer((inv) async => feedbackResponse);
  }
  if (trackingResponse != null) {
    when(service.sendTracking(any, any))
        .thenAnswer((inv) async => trackingResponse);
  }
  return service;
}

void mockFeedbackResponse(
  TrackingService service,
  Response feedbackResponse,
) {
  when(service.sendFeedback(any, any))
      .thenAnswer((inv) async => feedbackResponse);
}

SettingsService mockSettingsService() {
  return MockSettingsService();
}
