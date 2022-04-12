import 'dart:convert';

import 'package:carmanual/core/datasource/CarInfoDataSource.dart';
import 'package:carmanual/core/helper/tuple.dart';
import 'package:carmanual/core/network/app_client.dart';
import 'package:carmanual/core/tracking.dart';
import 'package:carmanual/models/car_info.dart';
import 'package:carmanual/models/schema_validater.dart';
import 'package:carmanual/models/sell_info.dart';
import 'package:carmanual/models/video_info.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

enum QrScanState { NEW, OLD, DAFUQ, WAITING, SCANNING }

class CarInfoService {
  CarInfoService(
    this._appClient,
    this.carInfoDataSource,
  );

  final AppClient _appClient;
  final CarInfoDataSource carInfoDataSource; //TODO private

  ValueNotifier<Tuple<double, double>> get progressValue =>
      _appClient.progressValue;

  Future<bool> _isOldCar(String brand, model) async {
    final allCars = await carInfoDataSource.getAllCars();
    return allCars.any((car) => car.brand == brand && car.model == model);
  }

  Future<bool> hasCars() async {
    final List<CarInfo> cars = await carInfoDataSource.getAllCars();
    if (cars.isEmpty) {
      return false;
    }
    return true;
  }

  Future<VideoInfo> getIntroVideo() async {
    final cars = await carInfoDataSource.getAllCars();
    return cars.first.introVideoUrl;
  }

  Future<Tuple<QrScanState, SellInfo>> onNewScan(String scan) async {
    Logger.logI("scan: $scan");
    try {
      Map<String, dynamic> scanJson = jsonDecode(scan);
      if (!await validateSellInfo(scanJson)) {
        throw Exception("sell key invalid");
      }

      final sellInfo = SellInfo.fromMap(scanJson);
      final isOldCar = await _isOldCar(sellInfo.brand, sellInfo.model);
      if (isOldCar) {
        return Tuple(QrScanState.OLD, sellInfo);
      } else {
        await _loadCarInfo(sellInfo.brand, sellInfo.model);
        return Tuple(QrScanState.NEW, sellInfo);
      }
    } on Exception catch (e) {
      Logger.logE("scan: ${e.toString()}");
    }
    return Tuple(QrScanState.DAFUQ, null);
  }

  Future _loadCarInfo(String brand, String model) async {
    final car = await _appClient.loadCarInfo(brand, model);
    await carInfoDataSource.addCarInfo(car);
  }

  Future updateCarInfo() async {
    final List<CarInfo> cars = await carInfoDataSource.getAllCars();
    await Future.forEach<CarInfo>(
      cars,
      (car) async {
        Logger.logI("Update Car: ${car.brand} ${car.model}");
        return await _loadCarInfo(car.brand, car.model);
      },
    );
  }

  Future<List<VideoInfo>> searchVideo(String query) async {
    final lowerQuery = query.toLowerCase();
    final cars = await carInfoDataSource.getAllCars();
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
  }
}
