import 'package:flutter/material.dart';
import 'package:qcar_business/core/misc/constants/urls.dart';
import 'package:qcar_business/core/models/Tracking.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_shared/network_service.dart';
import 'package:qcar_shared/tuple.dart';

class ServerClient implements DownloadClient, UploadClient {
  final ValueNotifier<Tuple<double, double>> progressValue =
      ValueNotifier(Tuple(0, 0));

  @override
  Future<Response> loadDealerInfo(String name) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.get,
        url: DEALER_INFO_URL,
        urlPath: ["dealer", name],
      ),
    );
  }

  Future<Response> loadCarInfo(DealerInfo info) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.get,
        url: DEALER_INFO_URL,
        urlPath: ["cars", info.name],
      ),
    );
  }

  @override
  Future<Response> loadSellerInfo(DealerInfo info) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.get,
        url: DEALER_INFO_URL,
        urlPath: ["sellers", info.name],
      ),
    );
  }

  @override
  Future<Response> loadCustomerInfo(DealerInfo info) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.get,
        url: DEALER_INFO_URL,
        urlPath: ["customers", info.name],
      ),
    );
  }

  @override
  Future<Response> loadSaleInfo(SellerInfo info) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.get,
        url: DEALER_INFO_URL,
        urlPath: ["sales", info.name],
      ),
    );
  }

  @override
  Future<Response> sendCustomerInfo(CustomerInfo info) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.post,
        url: DEALER_INFO_URL,
        urlPath: ["customer"],
        body: info.toJson(),
      ),
    );
  }

  @override
  Future<Response> sendSaleInfo(SaleInfo info) async {
    return await NetworkService.sendRequest(
      Request(
        requestType: RequestType.post,
        url: DEALER_INFO_URL,
        urlPath: ["sale"],
        body: info.toJson(),
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
