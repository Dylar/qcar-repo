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
    // final response=  await NetworkService.sendRequest(
    //   Request(
    //     requestType: RequestType.get,
    //     url: SELL_INFO_URL,
    //     body: key.toJson(),
    //   ),
    // );
    throw UnimplementedError();
  }

  Future<CarInfo> loadCarInfo(SellInfo info) async {
    throw UnimplementedError();
  }

  @override
  Future<Response> sendFeedback(Feedback feedback) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.post,
        url: FEEDBACK_URL,
        body: feedback.toJson(),
      ),
    );
  }

  @override
  Future<Response> sendTracking(TrackEvent event) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.post,
        url: TRACKING_URL,
        body: event.toJson(),
      ),
    );
  }
}
