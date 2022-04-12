import 'dart:async';

import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:rxdart/rxdart.dart';

abstract class CarInfoDataSource {
  Stream<List<CarInfo>> watchCarInfo();
  Future<void> addCarInfo(CarInfo info);
  Future<List<CarInfo>> getAllCars();
}

class CarInfoDS implements CarInfoDataSource {
  CarInfoDS(this._database);

  final AppDatabase _database;

  final streamController = BehaviorSubject<List<CarInfo>>();

  void dispose() {
    streamController.close();
  }

  @override
  Future<void> addCarInfo(CarInfo note) async {
    await _database.upsertCarInfo(note);
    streamController.sink.add(await _database.getCarInfos());
  }

  @override
  Future<List<CarInfo>> getAllCars() async {
    return _database.getCarInfos();
  }

  @override
  Stream<List<CarInfo>> watchCarInfo() {
    _database.getCarInfos().then((data) => streamController.add(data));
    return streamController;
  }
}
