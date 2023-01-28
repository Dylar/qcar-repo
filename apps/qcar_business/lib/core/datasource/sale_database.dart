import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_business/core/datasource/database.dart';
import 'package:qcar_business/core/models/sale_info.dart';

abstract class SaleInfoDatabase {
  Future<void> upsertSaleInfo(SaleInfo saleInfo);
  Future<List<SaleInfo>> getSaleInfos();
  Future<SaleInfo?> getSaleInfo(String brand, String model);
}

mixin SaleInfoDB implements SaleInfoDatabase {
  Box<SaleInfo> get saleInfoBox => Hive.box<SaleInfo>(BOX_SALE_INFO);

  //TODO make heil
  @override
  Future<void> upsertSaleInfo(SaleInfo info) async {
    await saleInfoBox.put(
      info.car.brand + info.car.model,
      info,
    );
  }

  @override
  Future<List<SaleInfo>> getSaleInfos() async {
    return saleInfoBox.values.toList();
  }

  @override
  Future<SaleInfo?> getSaleInfo(String brand, String model) async {
    return saleInfoBox.get(brand + model);
  }
}
