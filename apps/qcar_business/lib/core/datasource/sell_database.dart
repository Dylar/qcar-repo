import 'package:hive_flutter/hive_flutter.dart';
import 'package:qcar_business/core/datasource/database.dart';
import 'package:qcar_business/core/models/sell_info.dart';

abstract class SellInfoDatabase {
  Future<void> upsertSellInfo(SellInfo sellInfo);
  Future<List<SellInfo>> getSellInfos();
  Future<SellInfo?> getSellInfo(String brand, String model);
}

mixin SellInfoDB implements SellInfoDatabase {
  Box<SellInfo> get sellInfoBox => Hive.box<SellInfo>(BOX_SELL_INFO);

  //TODO make heil
  @override
  Future<void> upsertSellInfo(SellInfo sellInfo) async {
    await sellInfoBox.put(
      sellInfo.car.brand + sellInfo.car.model,
      sellInfo,
    );
  }

  @override
  Future<List<SellInfo>> getSellInfos() async {
    return sellInfoBox.values.toList();
  }

  @override
  Future<SellInfo?> getSellInfo(String brand, String model) async {
    return sellInfoBox.get(brand + model);
  }
}
