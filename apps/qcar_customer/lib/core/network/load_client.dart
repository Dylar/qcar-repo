import 'package:flutter/material.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/models/Feedback.dart' as fb;
import 'package:qcar_customer/models/Tracking.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';

abstract class DownloadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  Future<CarInfo> loadCarInfo(SellInfo info);

  Future<SellInfo> loadSellInfo(SellKey key);
}

abstract class UploadClient {
  Future<Response> sendFeedback(fb.Feedback feedback);

  Future<Response> sendTracking(TrackEvent event);
}
