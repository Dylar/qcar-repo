import 'package:flutter/material.dart';
import 'package:qcar_customer/core/misc/constants/urls.dart';
import 'package:qcar_customer/core/misc/helper/tuple.dart';
import 'package:qcar_customer/core/models/Feedback.dart' as fb;
import 'package:qcar_customer/core/models/Tracking.dart';
import 'package:qcar_customer/core/models/car_info.dart';
import 'package:qcar_customer/core/models/category_info.dart';
import 'package:qcar_customer/core/models/sell_info.dart';
import 'package:qcar_customer/core/models/sell_key.dart';
import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_customer/core/network/load_client.dart';
import 'package:qcar_customer/core/network/network_service.dart';

class ServerClient implements DownloadClient, UploadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  Future<Response> loadSellInfo(SellKey key) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.get,
        url: SELL_INFO_URL,
        urlPath: [key.key], //TODO make with params?
      ),
    );
  }

  Future<Response> loadCarInfo(SellInfo info) async {
    //TODO make get with one request

    final carResp = await NetworkService.sendRequest(
      Request(
        requestType: RequestType.get,
        url: CAR_INFO_URL,
        //TODO make with params?
        urlPath: [info.brand, info.model],
      ),
    );
    final car = CarInfo.fromMap(carResp.jsonMap!);
    fixCar(car);
    final maxProgress = info.videos.length.toDouble();
    progressValue.value = Tuple(maxProgress, 0);

    for (final category in info.videos.keys) {
      final catResp = await NetworkService.sendRequest(
        Request(
          requestType: RequestType.get,
          url: CATEGORY_INFO_URL,
          //TODO make with params?
          urlPath: [car.brand, car.model, category],
        ),
      );
      final cat = CategoryInfo.fromMap(catResp.jsonMap!);
      fixCategory(cat);
      car.categories.add(cat);

      for (final video in info.videos[category]!) {
        progressValue.value =
            Tuple(maxProgress, progressValue.value.secondOrThrow + 1);
        final vidResp = await NetworkService.sendRequest(
          Request(
            requestType: RequestType.get,
            url: VIDEO_INFO_URL,
            //TODO make with params?
            urlPath: [car.brand, car.model, category, video],
          ),
        );
        final vid = VideoInfo.fromMap(vidResp.jsonMap!);
        fixVideo(vid);
        cat.videos.add(vid);
      }
    }
    return Response.ok(jsonMap: car.toMap());
  }

  @override
  Future<Response> sendFeedback(fb.Feedback feedback) async {
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
