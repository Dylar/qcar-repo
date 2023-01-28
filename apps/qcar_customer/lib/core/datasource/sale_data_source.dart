import 'dart:async';

import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/core/models/sale_info.dart';

abstract class SaleInfoDataSource {
  Future<List<SaleInfo>> getAllSaleInfos();

  Future<void> addSaleInfo(SaleInfo info);
}

class SaleInfoDS implements SaleInfoDataSource {
  SaleInfoDS(this._database);

  final AppDatabase _database;

  @override
  Future<void> addSaleInfo(SaleInfo note) async {
    await _database.upsertSaleInfo(note);
  }

  @override
  Future<List<SaleInfo>> getAllSaleInfos() {
    return _database.getSaleInfos();
  }
}
