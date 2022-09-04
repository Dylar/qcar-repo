import 'package:flutter/material.dart';
import 'package:qcar_customer/core/environment_config.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/network/network_service.dart';
import 'package:qcar_customer/models/Feedback.dart' as fb;
import 'package:qcar_customer/models/Tracking.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/sell_info.dart';
import 'package:qcar_customer/models/sell_key.dart';
import 'package:qcar_customer/models/video_info.dart';

abstract class DownloadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  Future<Response> loadCarInfo(SellInfo info);

  Future<Response> loadSellInfo(SellKey key);
}

abstract class UploadClient {
  Future<Response> sendFeedback(fb.Feedback feedback);

  Future<Response> sendTracking(TrackEvent event);
}

//TODO DELETE THE FIX METHODS

//TODO fix me in DB
void fixSell(SellInfo info) {
  info
    ..introFilePath =
        "https://${EnvironmentConfig.domain}/videos/${info.brand}/${info.model}/qCar Intro.mp4";
}

//TODO fix me in DB
void fixCar(CarInfo car) =>
    car.imagePath = "${car.brand}/${car.model}/${car.imagePath}";

//TODO fix me in DB
void fixCategory(CategoryInfo category) {
  category.imagePath =
      "${category.brand}/${category.model}/${category.name}/${category.imagePath}";
}

//TODO fix me in DB
void fixVideo(VideoInfo video) {
  video.filePath =
      "${video.brand}/${video.model}/${video.category}/${video.name}/${video.filePath}";
  video.imagePath =
      "${video.brand}/${video.model}/${video.category}/${video.name}/${video.imagePath}";
}
