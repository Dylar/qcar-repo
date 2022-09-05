import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SellInfoDataSource.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/logger.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/mixins/scan_fun.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/video_info.dart';

class InfoService {
  InfoService(
    this._loadClient,
    this.carInfoDataSource,
    this._sellInfoDataSource,
  );

  final DownloadClient _loadClient;
  final CarInfoDataSource carInfoDataSource; //TODO private
  final SellInfoDataSource _sellInfoDataSource;

  ValueNotifier<Tuple<double, double>> get progressValue =>
      _loadClient.progressValue;

  Stream<List<CarInfo>> watchCarInfo() => carInfoDataSource.watchCarInfo();

  Future<bool> _isOldCar(String brand, String model) async {
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

  Future<String> getIntroVideo() async {
    final sells = await _sellInfoDataSource.getAllSellInfos();
    return sells.first.introFilePath;
  }

  Future<Tuple<QrScanState, SellInfo>> onNewScan(String scan) async {
    Logger.logI("scan: $scan");
    try {
      final sellInfo = await _loadSellInfo(scan);

      final isOldCar = await _isOldCar(sellInfo.brand, sellInfo.model);
      if (isOldCar) {
        return Tuple(QrScanState.OLD, sellInfo);
      } else {
        await _loadCarInfo(sellInfo);
        await _sellInfoDataSource.addSellInfo(sellInfo);
        return Tuple(QrScanState.NEW, sellInfo);
      }
    } on Exception catch (e) {
      Logger.logE("scan error: ${e.toString()}");
    }
    return Tuple(QrScanState.DAFUQ, null);
  }

  Future<SellInfo> _loadSellInfo(String scan) async {
    final key = SellKey.fromScan(scan);
    final response = await _loadClient.loadSellInfo(key);
    if (response.status == ResponseStatus.OK) {
      return SellInfo.fromMap(response.jsonMap!);
    } //TODO on error
    throw Exception("ERROR ON SELL INFO LOAD");
  }

  Future _loadCarInfo(SellInfo info) async {
    final car = await _loadClient.loadCarInfo(info);
    if (car.status == ResponseStatus.OK) {
      await carInfoDataSource.addCarInfo(CarInfo.fromMap(car.jsonMap!));
    } //TODO on error
  }

  Future refreshCarInfos() async {
    final infos = await _sellInfoDataSource.getAllSellInfos();
    for (final info in infos) {
      Logger.logI("Refresh Car: ${info.brand} ${info.model}");
      return await _loadCarInfo(info);
    }
  }

  Future<List<VideoInfo>> searchVideo(String query) async {
    return await carInfoDataSource.findVideos(query);
  }
}
