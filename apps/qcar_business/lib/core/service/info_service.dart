import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_shared/network_service.dart';

class InfoService {
  InfoService(this.downClient);

  final DownloadClient downClient;

  List<CarInfo> cars = [];
  List<VideoInfo> videos = [];

  List<SellerInfo> sellers = [];
  List<CustomerInfo> customers = [];
  List<SellInfo> sellInfos = [];

  Future<void> loadDealerInfos(DealerInfo info) async {
    await Future.wait([
      downClient.loadCarInfo(info).then((rsp) {
        if (rsp.status == ResponseStatus.OK) {
          cars = rsp.jsonList
              .map((e) => CarInfo.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      }),
      downClient.loadSellerInfo(info).then((rsp) {
        if (rsp.status == ResponseStatus.OK) {
          sellers = rsp.jsonList
              .map((e) => SellerInfo.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      }),
      downClient.loadCustomerInfo(info).then((rsp) {
        if (rsp.status == ResponseStatus.OK) {
          customers = rsp.jsonList
              .map((e) => CustomerInfo.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      }),
    ]);
  }

  Future<void> loadSellerInfos(SellerInfo info) async {
    await Future.wait([
      downClient.loadSellInfo(info).then((rsp) {
        if (rsp.status == ResponseStatus.OK) {
          sellInfos = rsp.jsonList
              .map((e) => SellInfo.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      }),
    ]);
  }

  void sellCar(SellInfo info) {
    if (!customers.contains(info.customer)) {
      customers.add(info.customer);
    }
    sellInfos.add(info);
  }

  List<CustomerInfo> searchCustomer(String query) {
    final Set<CustomerInfo> result = {};
    result.addAll(customers.where((c) => c.lastName.contains(query)));
    result.addAll(customers.where((c) => c.email.contains(query)));
    result.addAll(customers.where((c) => c.name.contains(query)));
    return result.toList();
  }
}
