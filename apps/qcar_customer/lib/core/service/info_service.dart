import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:qcar_customer/core/datasource/car_data_source.dart';
import 'package:qcar_customer/core/datasource/favorite_data_source.dart';
import 'package:qcar_customer/core/datasource/sale_data_source.dart';
import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/favorite.dart';
import 'package:qcar_customer/core/models/sale_info.dart';
import 'package:qcar_customer/core/models/sale_key.dart';
import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_shared/network_service.dart';
import 'package:qcar_shared/tuple.dart';
import 'package:qcar_shared/utils/logger.dart';

class InfoService {
  InfoService(
    this._loadClient,
    this._carInfoDataSource,
    this._saleInfoDataSource,
    this._favoriteDataSource,
  );

  final DownloadClient _loadClient;
  final CarInfoDataSource _carInfoDataSource;
  final SaleInfoDataSource _saleInfoDataSource;
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
    final List<SaleInfo> sales = await _saleInfoDataSource.getAllSaleInfos();
    return cars.isNotEmpty && sales.isNotEmpty; //TODO test both empty
  }

  Future<String> getIntroVideo() async {
    final sales = await _saleInfoDataSource.getAllSaleInfos();
    return fixIntroPath(sales.first); //TODO remember last selected
  }

  Future<SaleInfo> loadSaleInfo(String scan) async {
    final key = SaleKey.fromScan(scan);
    final response = await _loadClient.loadSaleInfo(key);
    if (response.status == ResponseStatus.OK) {
      return SaleInfo.fromMap(response.jsonMap!);
    } //TODO on error
    throw Exception("ERROR ON SALE INFO LOAD");
  }

  Future loadCarInfo(SaleInfo info) async {
    final car = await _loadClient.loadCarInfo(info);
    if (car.status == ResponseStatus.OK) {
      return await _carInfoDataSource.addCarInfo(CarInfo.fromMap(car.jsonMap!));
    } //TODO on error
    throw Exception("ERROR ON CAR INFO LOAD");
  }

  Future<bool> isOldCar(String brand, String model) async {
    final cars = await _carInfoDataSource.getAllCars();
    final List<SaleInfo> sales = await _saleInfoDataSource.getAllSaleInfos();
    return cars.any((car) => car.brand == brand && car.model == model) &&
        sales.any((sale) => sale.brand == brand && sale.model == model);
  }

  Future refreshCarInfos() async {
    final infos = await _saleInfoDataSource.getAllSaleInfos();
    for (final info in infos) {
      Logger.logI("Refresh Car: ${info.brand} ${info.model}");
      return await loadCarInfo(info);
    }
  }

  Future<List<VideoInfo>> searchVideo(String query) async {
    return await _carInfoDataSource.findVideos(query);
  }

  Future upsertSaleInfo(SaleInfo saleInfo) async {
    _saleInfoDataSource.addSaleInfo(saleInfo);
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
