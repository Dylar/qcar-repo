import 'dart:async';

import 'package:qcar_business/core/datasource/database.dart';
import 'package:qcar_business/core/models/car_info.dart';

abstract class CarInfoDataSource {
  Stream<List<CarInfo>> watchCarInfo();

  Future<void> addCarInfo(CarInfo info);

  Future<List<CarInfo>> getAllCars();
}

class CarInfoDS implements CarInfoDataSource {
  CarInfoDS(this._database);

  final AppDatabase _database;

  final streamController = StreamController<List<CarInfo>>();

  void dispose() {
    streamController.close();
  }

  @override
  Future<void> addCarInfo(CarInfo note) async {
    await _database.upsertCarInfo(note);
    final list = await _database.getCarInfos();
    streamController.sink.add(list);
  }

  @override
  Future<List<CarInfo>> getAllCars() async {
    return _database.getCarInfos();
  }

  @override
  Stream<List<CarInfo>> watchCarInfo() {
    _database.getCarInfos().then((data) => streamController.add(data));
    return streamController.stream;
  }
}
