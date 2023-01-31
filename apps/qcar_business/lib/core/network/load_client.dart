import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/Tracking.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_shared/network_service.dart';
import 'package:qcar_shared/tuple.dart';

abstract class DownloadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  Future<Response> loadCarInfo(DealerInfo info);
  Future<Response> loadSellerInfo(DealerInfo info);
  Future<Response> loadCustomerInfo(DealerInfo info);

  Future<Response> loadSaleInfo(SellerInfo info);
}

abstract class UploadClient {
  Future<Response> sendCustomerInfo(CustomerInfo info);
  Future<Response> sendSaleInfo(SaleInfo info);
  Future<Response> sendTracking(TrackEvent event);
}

//TODO DELETE THE FIX METHODS

//TODO fix me in DB
void fixCar(CarInfo car) =>
    car.imagePath = "${car.brand}/${car.model}/${car.imagePath}";

//TODO fix me in DB
void fixVideo(VideoInfo video) {
  video.videoImagePath =
      "${video.brand}/${video.model}/${video.category}/${video.name}/${video.videoImagePath}";
  video.categoryImagePath =
      "${video.brand}/${video.model}/${video.category}/${video.categoryImagePath}";
}
