import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:qcar_customer/core/datasource/car_data_source.dart';
import 'package:qcar_customer/core/datasource/favorite_data_source.dart';
import 'package:qcar_customer/core/datasource/sell_data_source.dart';
import 'package:qcar_customer/core/misc/helper/logger.dart';
import 'package:qcar_customer/core/misc/helper/tuple.dart';
import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/favorite.dart';
import 'package:qcar_customer/core/models/sell_info.dart';
import 'package:qcar_customer/core/models/sell_key.dart';
import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';

class InfoService {
  InfoService(
    this._loadClient,
    this._carInfoDataSource,
    this._sellInfoDataSource,
    this._favoriteDataSource,
  );

  final DownloadClient _loadClient;
  final CarInfoDataSource _carInfoDataSource;
  final SellInfoDataSource _sellInfoDataSource;
  final FavoriteDataSource _favoriteDataSource;

  ValueNotifier<Tuple<double, double>> get progressValue =>
      _loadClient.progressValue;

  Future<List<CarInfo>> getAllCars() => _carInfoDataSource.getAllCars();

  Stream<List<CarInfo>> watchCarsInfo() => _carInfoDataSource.watchCarInfo();

  Stream<CarInfo> watchCarInfo(CarInfo selectedCar) {
    return _carInfoDataSource.watchCarInfo().map((event) {
      return event.firstWhere((car) =>
          car.model == selectedCar.model && car.brand == selectedCar.brand);
    });
  }

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

  Future<bool> isFavorite(VideoInfo video) async =>
      (await _favoriteDataSource.getFavorite(
          video.brand, video.model, video.category, video.name)) !=
      null;

  Future<List<Favorite>> getFavorites(CarInfo car) async =>
      (await _favoriteDataSource.getFavorites(car.brand, car.model));

  Stream<Iterable<Favorite>> watchFavorites(CarInfo selectedCar) async* {
    yield* _favoriteDataSource.watchFavorites().map((event) {
      return event.where((fav) =>
          fav.brand == selectedCar.brand && fav.model == selectedCar.model);
    });
  }

  void toggleFavorite(VideoInfo video, bool isFavorite) {
    final favorite = video.toFavorite;
    if (isFavorite) {
      _favoriteDataSource.upsertFavorite(favorite);
    } else {
      _favoriteDataSource.deleteFavorite(favorite);
    }
  }
}
