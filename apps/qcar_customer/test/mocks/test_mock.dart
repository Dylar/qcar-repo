import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SettingsDataSource.dart';
import 'package:qcar_customer/core/datasource/VideoInfoDataSource.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/settings.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/service/auth_service.dart';

import '../builder/entity_builder.dart';
import '../ui/screens/intro_test.mocks.dart';
import 'http_client_mock.dart';

HttpOverrides mockHttpOverrides() => MockHttpOverrides();

LoadClient mockLoadClient() {
  final client = MockLoadClient();
  when(client.loadCarInfo(any, any)).thenAnswer((inv) async {
    final brand = inv.positionalArguments[0];
    final model = inv.positionalArguments[1];
    final car = await buildCarInfo();
    car.brand = brand;
    car.model = model;

    //TODO maybe delete me if we got the urls right
    car.categories.forEach((category) {
      category.videos.forEach((vid) {
        vid.brand = car.brand;
        vid.model = car.model;
      });
    });
    return car;
  });

  when(client.loadSellInfo(any)).thenAnswer((inv) async {
    final key = inv.positionalArguments[0] as SellKey;
    final sellInfo = await buildSellInfo();
    if (sellInfo.key == key.key) {
      return sellInfo;
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

VideoInfoDataSource mockVideoSource() {
  final source = MockVideoInfoDataSource();
  final videos = <VideoInfo>[];
  when(source.getVideos(any)).thenAnswer((inv) async {
    final CarInfo car = inv.positionalArguments.first;
    return videos.where((vid) {
      return vid.vidUrl.contains(car.brand) && vid.vidUrl.contains(car.model);
    }).toList();
  });
  when(source.hasVideosLoaded(any)).thenAnswer((inv) async {
    final CarInfo car = inv.positionalArguments.first;
    return videos.any((vid) {
      return vid.vidUrl.contains(car.brand) && vid.vidUrl.contains(car.model);
    });
  });
  when(source.upsertVideo(any)).thenAnswer((inv) async {
    videos.add(inv.positionalArguments.first);
    return true;
  });
  return source;
}

AuthenticationService mockAuthService() {
  final service = MockAuthenticationService();
  when(service.signInAnon()).thenAnswer((inv) async {
    return "Signed in";
  });
  return service;
}
