import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:qcar_customer/core/datasource/CarInfoDataSource.dart';
import 'package:qcar_customer/core/datasource/SellInfoDataSource.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/logger.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/video_info.dart';

class InfoService {
  InfoService(
    this._loadClient,
    this._carInfoDataSource,
    this._sellInfoDataSource,
  );

  final DownloadClient _loadClient;
  final CarInfoDataSource _carInfoDataSource;
  final SellInfoDataSource _sellInfoDataSource;

  ValueNotifier<Tuple<double, double>> get progressValue =>
      _loadClient.progressValue;

  Future<List<CarInfo>> getAllCars() => _carInfoDataSource.getAllCars();

  Stream<List<CarInfo>> watchCarInfo() => _carInfoDataSource.watchCarInfo();

  Future<bool> hasCars() async {
    final List<CarInfo> cars = await _carInfoDataSource.getAllCars();
    final List<SellInfo> sells = await _sellInfoDataSource.getAllSellInfos();
    return cars.isNotEmpty && sells.isNotEmpty; //TODO test both empty
  }

  Future<String> getIntroVideo() async {
    final sells = await _sellInfoDataSource.getAllSellInfos();
    return fixIntroPath(sells.first); //TODO remember last selected
  }

  Future<SellInfo> loadSellInfo(String scan) async {
    final key = SellKey.fromScan(scan);
    final response = await _loadClient.loadSellInfo(key);
    if (response.status == ResponseStatus.OK) {
      return SellInfo.fromMap(response.jsonMap!);
    } //TODO on error
    throw Exception("ERROR ON SELL INFO LOAD");
  }

  Future loadCarInfo(SellInfo info) async {
    final car = await _loadClient.loadCarInfo(info);
    if (car.status == ResponseStatus.OK) {
      return await _carInfoDataSource.addCarInfo(CarInfo.fromMap(car.jsonMap!));
    } //TODO on error
    throw Exception("ERROR ON CAR INFO LOAD");
  }

  Future<bool> isOldCar(String brand, String model) async {
    final cars = await _carInfoDataSource.getAllCars();
    final List<SellInfo> sells = await _sellInfoDataSource.getAllSellInfos();
    return cars.any((car) => car.brand == brand && car.model == model) &&
        sells.any((sell) => sell.brand == brand && sell.model == model);
  }

  Future refreshCarInfos() async {
    final infos = await _sellInfoDataSource.getAllSellInfos();
    for (final info in infos) {
      Logger.logI("Refresh Car: ${info.brand} ${info.model}");
      return await loadCarInfo(info);
    }
  }

  Future<List<VideoInfo>> searchVideo(String query) async {
    return await _carInfoDataSource.findVideos(query);
  }

  Future upsertSellInfo(SellInfo sellInfo) async {
    _sellInfoDataSource.addSellInfo(sellInfo);
  }
}
