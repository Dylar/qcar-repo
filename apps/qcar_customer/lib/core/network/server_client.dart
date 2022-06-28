import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/video_info.dart';

//TODO load through backend
class ServerClient implements LoadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  Future<SellInfo> loadSellInfo(SellKey key) async {
    // final response = await NetworkService.sendRequest(
    //     requestType: RequestType.get, url: EnvironmentConfig.backendUrl);
    throw UnimplementedError();
  }

  Future<CarInfo> loadCarInfo(String? brand, String? model) async {
        throw UnimplementedError();
  }

}
