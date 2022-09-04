import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SellInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/settings.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/service/auth_service.dart';
import 'package:qcar_customer/service/settings_service.dart';
import 'package:qcar_customer/service/upload_service.dart';

import '../builder/entity_builder.dart';
import '../ui/screens/app/app_test.mocks.dart';
import 'http_client_mock.dart';

HttpOverrides mockHttpOverrides() => MockHttpOverrides();

UploadClient mockUploadClient() {
  return MockUploadClient();
}

DownloadClient mockDownloadClient() {
  final client = MockDownloadClient();
  when(client.loadCarInfo(any)).thenAnswer((inv) async {
    final info = inv.positionalArguments[0] as SellInfo;
    final car = await buildCarInfo();
    car.brand = info.brand;
    car.model = info.model;

    //TODO maybe delete me if we got the urls right
    car.categories.forEach((category) {
      category.videos.forEach((vid) {
        vid.brand = car.brand;
        vid.model = car.model;
      });
    });
    return Response.ok(jsonMap: car.toMap());
  });

  when(client.loadSellInfo(any)).thenAnswer((inv) async {
    final key = inv.positionalArguments[0] as SellKey;
    final sellInfo = await buildSellInfo();
    if (sellInfo.key == key.key) {
      return Response.ok(jsonMap: sellInfo.toMap());
    }
    throw Exception("WRONG KEY");
  });

  when(client.progressValue).thenReturn(ValueNotifier(Tuple(1, 1)));
  return client;
}

SettingsDataSource mockSettings() {
  final source = MockSettingsDataSource();
  var settings = Settings();
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

SellInfoDataSource mockSellSource({List<SellInfo>? initialSellInfo}) {
  final source = MockSellInfoDataSource();
  final sells = initialSellInfo ?? [];
  when(source.getAllSellInfos()).thenAnswer((_) async => sells);
  when(source.addSellInfo(any)).thenAnswer((inv) async {
    final info = inv.positionalArguments.first;
    if (!sells.any((e) => e.brand == info.brand && e.model == info.model)) {
      sells.add(info);
    }
  });
  return source;
}

AuthenticationService mockAuthService({bool isLoggedIn = true}) {
  final service = MockAuthenticationService();
  when(service.signInAnon()).thenAnswer((inv) async => isLoggedIn);
  return service;
}

UploadService mockUploadService({
  Response? feedbackResponse,
  Response? trackingResponse,
}) {
  final service = MockUploadService();
  if (feedbackResponse != null) {
    when(service.sendFeedback(any)).thenAnswer((inv) async => feedbackResponse);
  }
  if (trackingResponse != null) {
    when(service.sendTracking(any)).thenAnswer((inv) async => trackingResponse);
  }
  return service;
}

void mockFeedbackResponse(
  UploadService service,
  Response feedbackResponse,
) {
  when(service.sendFeedback(any)).thenAnswer((inv) async => feedbackResponse);
}

SettingsService mockSettingsService() {
  return MockSettingsService();
}
