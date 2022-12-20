import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class SoldViewModel extends ViewModel {
  SellInfo get sellInfo;
}

class SoldVM extends SoldViewModel {
  SoldVM(this.infoService, this.sellInfo);

  final InfoService infoService;
  final SellInfo sellInfo;

  @override
  void routingDidPush() {
    super.routingDidPush();
    notifyListeners();
  }
}
