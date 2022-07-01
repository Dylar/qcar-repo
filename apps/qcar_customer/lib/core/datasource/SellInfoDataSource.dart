import 'dart:async';

import 'package:qcar_customer/core/datasource/database.dart';
import 'package:qcar_customer/models/sell_info.dart';

abstract class SellInfoDataSource {
  Future<List<SellInfo>> getAllSellInfos();

  Future<void> addSellInfo(SellInfo info);
}

class SellInfoDS implements SellInfoDataSource {
  SellInfoDS(this._database);

  final AppDatabase _database;

  @override
  Future<void> addSellInfo(SellInfo note) async {
    await _database.upsertSellInfo(note);
  }

  @override
  Future<List<SellInfo>> getAllSellInfos() {
    return _database.getSellInfos();
  }
}
