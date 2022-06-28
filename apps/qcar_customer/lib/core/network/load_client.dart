import 'package:flutter/material.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';

abstract class LoadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  Future<CarInfo> loadCarInfo(String? brand, String? model);

  Future<SellInfo> loadSellInfo(SellKey key);
}
