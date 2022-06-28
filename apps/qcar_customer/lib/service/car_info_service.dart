import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/tracking.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/video_info.dart';

enum QrScanState { NEW, OLD, DAFUQ, WAITING, SCANNING }

class CarInfoService {
  CarInfoService(
    this._loadClient,
    this.carInfoDataSource,
  );

  final LoadClient _loadClient;
  final CarInfoDataSource carInfoDataSource; //TODO private

  ValueNotifier<Tuple<double, double>> get progressValue =>
      _loadClient.progressValue;

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
    //TODO get info from seller
    final cars = await carInfoDataSource.getAllCars();
    return cars.first.introVideoUrl;
  }

  Future<Tuple<QrScanState, SellInfo>> onNewScan(String scan) async {
    Logger.logI("scan: $scan");
    try {
      final sellInfo = await _loadSellInfo(scan);
      final isOldCar = await _isOldCar(sellInfo.brand, sellInfo.model);
      if (isOldCar) {
        return Tuple(QrScanState.OLD, sellInfo);
      } else {
        await _loadCarInfo(sellInfo.brand, sellInfo.model);
        return Tuple(QrScanState.NEW, sellInfo);
      }
    } on Exception catch (e) {
      Logger.logE("scan error: ${e.toString()}");
    }
    return Tuple(QrScanState.DAFUQ, null);
  }

  Future _loadCarInfo(String brand, String model) async {
    final car = await _loadClient.loadCarInfo(brand, model);
    await carInfoDataSource.addCarInfo(car);
  }

  Future refreshCarInfos() async {
    final cars = await carInfoDataSource.getAllCars();
    for (final car in cars) {
      Logger.logI("Refresh Car: ${car.brand} ${car.model}");
      return await _loadCarInfo(car.brand, car.model);
    }
  }

  Future<List<VideoInfo>> searchVideo(String query) async {
    return await carInfoDataSource.findVideos(query);
  }

  Future<SellInfo> _loadSellInfo(String scan) async {
    final key = SellKey.fromScan(scan);
    return await _loadClient.loadSellInfo(key);
  }
}
