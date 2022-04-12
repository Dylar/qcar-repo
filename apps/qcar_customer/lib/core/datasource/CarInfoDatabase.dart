import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/models/car_info.dart';

abstract class CarInfoDatabase {
  Future<void> upsertCarInfo(CarInfo carInfo);
  Future<List<CarInfo>> getCarInfos();
  Future<CarInfo?> getCarInfo(String name);
}

mixin CarInfoDB implements CarInfoDatabase {
  Box<CarInfo> get carInfoBox => Hive.box<CarInfo>(BOX_CAR_INFO);

  @override
  Future<void> upsertCarInfo(CarInfo carInfo) async {
    await carInfoBox.put(
      carInfo.brand + carInfo.model,
      carInfo,
    );
  }

  @override
  Future<List<CarInfo>> getCarInfos() async {
    return carInfoBox.values.toList();
  }

  @override
  Future<CarInfo?> getCarInfo(String name) async {
    return carInfoBox.get(name);
  }
}
