import 'package:mockito/mockito.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/network/load_client.dart';
import 'package:qcar_shared/network_service.dart';

import '../builder/entity_builder.dart';

Future<void> mockDownloadClient({
  required DownloadClient client,
  DealerInfo? dealerInfo,
  List<CarInfo>? carInfos,
  List<SellerInfo>? sellerInfos,
  List<CustomerInfo>? customerInfos,
  Map<String, List<SaleInfo>>? saleInfos,
}) async {
  final dealer = dealerInfo ?? await buildDealerInfo();
  when(client.loadDealerInfo(dealer.name)).thenAnswer((inv) async {
    return Response.ok(json: dealer.toJson());
  });
  final cars = carInfos ?? [await buildCarInfo()];
  when(client.loadCarInfo(dealer)).thenAnswer((inv) async {
    return Response.ok(json: CarInfo.toListJson(cars));
  });
  final sellers = sellerInfos ?? [await buildSellerInfo()];
  when(client.loadSellerInfo(dealer)).thenAnswer((inv) async {
    return Response.ok(json: SellerInfo.toListJson(sellers));
  });
  final customers = customerInfos ?? [await buildCustomerInfo()];
  when(client.loadCustomerInfo(dealer)).thenAnswer((inv) async {
    return Response.ok(json: CustomerInfo.toListJson(customers));
  });

  await Future.forEach(sellers, (seller) async {
    List<SaleInfo> sales = saleInfos?[seller] ?? [await buildSaleInfo()];
    sales = sales.map((sale) => sale.copy(seller: seller)).toList();
    when(client.loadSaleInfo(seller)).thenAnswer((inv) async {
      return Response.ok(json: SaleInfo.toListJson(sales));
    });
  });
}

mockClientDealerError({
  required DownloadClient client,
  required String name,
  ResponseStatus status = ResponseStatus.NOT_FOUND,
}) {
  when(client.loadDealerInfo(name)).thenAnswer((inv) async => Response(status));
}
