import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/models/sale_info.dart';

abstract class SaleInfoDatabase {
  Future<void> upsertSaleInfo(SaleInfo saleInfo);
  Future<List<SaleInfo>> getSaleInfos();
  Future<SaleInfo?> getSaleInfo(String brand, String model);
}

mixin SaleInfoDB implements SaleInfoDatabase {
  Box<SaleInfo> get saleInfoBox => Hive.box<SaleInfo>(BOX_SALE_INFO);

  @override
  Future<void> upsertSaleInfo(SaleInfo saleInfo) async {
    await saleInfoBox.put(
      saleInfo.brand + saleInfo.model,
      saleInfo,
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
