import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/Tracking.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_shared/network_service.dart';
import 'package:qcar_shared/tuple.dart';
import 'package:qcar_shared/utils/logger.dart';

class MockClient implements DownloadClient, UploadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  @override
  Future<Response> loadDealerInfo(String name) async {
    if (dealer.name == name) {
      return Response.ok(json: dealer.toJson());
    }
    return Response(ResponseStatus.NOT_FOUND);
  }

  Future<Response> loadCarInfo(DealerInfo info) async =>
      Response.ok(json: CarInfo.toListJson(cars));

  @override
  Future<Response> loadSellerInfo(DealerInfo info) async =>
      Response.ok(json: SellerInfo.toListJson(sellers));

  @override
  Future<Response> loadCustomerInfo(DealerInfo info) async =>
      Response.ok(json: CustomerInfo.toListJson(customers));

  @override
  Future<Response> loadSaleInfo(SellerInfo info) async =>
      Response.ok(json: SaleInfo.toListJson(getSaleInfos(info)));

  @override
  Future<Response> sendCustomerInfo(CustomerInfo info) async {
    Logger.logD(info.toJson());
    return Response.ok(json: "ok");
  }

  @override
  Future<Response> sendSaleInfo(SaleInfo info) async {
    Logger.logD(info.toJson());
    return Response.ok(json: "ok");
  }

  @override
  Future<Response> sendTracking(TrackEvent event) async {
    Logger.logTrack(event.text);
    return Response.ok(json: "ok");
  }

  DealerInfo dealer = DealerInfo(name: "Autohaus", address: 'Bla street');
  List<SellerInfo> sellers = [
    SellerInfo(dealer: "Autohaus", name: "Maxi"),
    SellerInfo(dealer: "Autohaus", name: "Kolja"),
  ];
  List<CarInfo> cars = [
    CarInfo(
      brand: "Opel",
      model: "Corsa",
      imagePath: "Toyota/CorollaTSGR/CorollaTSGR.jpg",
    ),
    CarInfo(
      brand: "Toyota",
      model: "Corolla",
      imagePath: "Toyota/CorollaTSGR/CorollaTSGR.jpg",
    ),
  ];
  List<VideoInfo> _videos = [];
  List<CustomerInfo> customers = [
    CustomerInfo(
      dealer: "Autohaus",
      name: "Peter",
      lastName: "Lustig",
      gender: Gender.MALE,
      birthday: "2001-09-11 09:35:00.000",
      phone: "0190666666",
      email: "peter.lustig@gmx.de",
    )
  ];
  Map<String, List<SaleInfo>> saleInfos = {};

  List<VideoInfo> getVideos() {
    if (_videos.isEmpty) {
      final car1 = cars.first;
      _videos.add(VideoInfo(
        brand: car1.brand,
        model: car1.model,
        category: "Sicherheit",
        name: "Smart-Key, Keyless Go",
        categoryImagePath: "Toyota/CorollaTSGR/Sicherheit/Sicherheit.jpg",
        videoImagePath:
            "Toyota/CorollaTSGR/Sicherheit/Smart-Key, Keyless Go/Smart-Key, Keyless Go.jpg",
      ));
      _videos.add(VideoInfo(
        brand: car1.brand,
        model: car1.model,
        category: "Sicherheit",
        name: "Gurt",
        categoryImagePath: "Toyota/CorollaTSGR/Sicherheit/Sicherheit.jpg",
        videoImagePath:
            "Toyota/CorollaTSGR/Sicherheit/Smart-Key, Keyless Go/Smart-Key, Keyless Go.jpg",
      ));

      _videos.add(VideoInfo(
        brand: car1.brand,
        model: car1.model,
        category: "Räder & Reifen",
        name: "Reifenreparaturset",
        categoryImagePath: "Toyota/CorollaTSGR/Räder & Reifen/Reifen.jpg",
        videoImagePath:
            "Toyota/CorollaTSGR/Sicherheit/Räder & Reifen/reifenreparatur.jpg",
      ));

      final car2 = cars.last;
      _videos.add(VideoInfo(
        brand: car2.brand,
        model: car2.model,
        category: "Sicherheit",
        name: "Rückfahrkamera",
        categoryImagePath: "Toyota/CorollaTSGR/Sicherheit/Sicherheit.jpg",
        videoImagePath:
            "Toyota/CorollaTSGR/Sicherheit/Rückfahrkamera/Rückfahrkamera.jpg",
      ));
    }
    return _videos;
  }

  List<SaleInfo> getSaleInfos(SellerInfo sellerInfo) {
    final selectedVideos = <String, List<VideoInfo>>{};
    getVideos().forEach((video) {
      final list = selectedVideos[video.category] ?? [];
      list.add(video);
      selectedVideos[video.category] = list;
    });
    return saleInfos[sellerInfo.name] ??
        [
          SaleInfo(
            seller: sellerInfo,
            car: cars.first,
            videos: selectedVideos.map((key, value) =>
                MapEntry(key, value.map((e) => e.name).toList())),
            customer: customers.first,
          ),
          SaleInfo(
            seller: sellerInfo,
            car: cars.last,
            videos: selectedVideos.map((key, value) =>
                MapEntry(key, value.map((e) => e.name).toList())),
            customer: customers.first,
          )
        ];
  }
}
