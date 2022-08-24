import 'package:flutter/foundation.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/endpoints.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/models/Feedback.dart';
import 'package:qcar_customer/models/Tracking.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';

//TODO load through backend
class ServerClient implements DownloadClient, UploadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  Future<SellInfo> loadSellInfo(SellKey key) async {
    // final response = await NetworkService.sendRequest(
    //     requestType: RequestType.get, url: EnvironmentConfig.backendUrl);
    throw UnimplementedError();
  }

  Future<CarInfo> loadCarInfo(SellInfo info) async {
    throw UnimplementedError();
  }

  @override
  Future sendFeedback(Feedback feedback) async {
    await NetworkService.sendRequest(
        requestType: RequestType.post,
        url: FEEDBACK_URL,
        body: feedback.toJson());
  }

  @override
  Future sendTracking(TrackEvent event) {
    // TODO: implement sendTracking
    throw UnimplementedError();
  }
}
