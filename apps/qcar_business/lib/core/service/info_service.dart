import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_shared/network_service.dart';

class InfoService {
  InfoService(this.downClient);

  final DownloadClient downClient;

  List<CarInfo> _cars = [];
  List<VideoInfo> _videos = [];

  List<SellerInfo> _sellers = [];
  List<CustomerInfo> _customers = [];
  List<SaleInfo> _saleInfos = [];

  Future<void> loadDealerInfos(DealerInfo info) async {
    await Future.wait([
      downClient.loadCarInfo(info).then((rsp) {
        if (rsp.status == ResponseStatus.OK) {
          _cars = rsp.jsonList
              .map((e) => CarInfo.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      }),
      downClient.loadSellerInfo(info).then((rsp) {
        if (rsp.status == ResponseStatus.OK) {
          _sellers = rsp.jsonList
              .map((e) => SellerInfo.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      }),
      downClient.loadCustomerInfo(info).then((rsp) {
        if (rsp.status == ResponseStatus.OK) {
          _customers = rsp.jsonList
              .map((e) => CustomerInfo.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      }),
    ]);
  }

  Future<void> loadSellerInfos(SellerInfo info) async {
    await Future.wait([
      downClient.loadSaleInfo(info).then((rsp) {
        if (rsp.status == ResponseStatus.OK) {
          _saleInfos = rsp.jsonList
              .map((e) => SaleInfo.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      }),
    ]);
  }

  List<CarInfo> getCars() => _cars;
  List<VideoInfo> getVideos() => _videos;

  List<SellerInfo> getSeller(DealerInfo info) =>
      _sellers.where((element) => element.dealer == info.name).toList();

  List<SaleInfo> getSaleInfos(SellerInfo currentUser) =>
      _saleInfos.where((e) => e.seller == currentUser).toList();

  List<CustomerInfo> searchCustomer(String query) {
    final Set<CustomerInfo> result = {};
    result.addAll(_customers.where((c) => c.lastName.contains(query)));
    result.addAll(_customers.where((c) => c.email.contains(query)));
    result.addAll(_customers.where((c) => c.name.contains(query)));
    return result.toList();
  }

  void sellCar(SaleInfo info) {
    if (!_customers.contains(info.customer)) {
      _customers.add(info.customer); // TODO upload new customer
    }
    _saleInfos.add(info); // TODO upload sale
  }
}
