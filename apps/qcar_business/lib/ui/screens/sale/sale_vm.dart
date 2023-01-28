import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class SaleViewModel extends ViewModel {
  SaleInfo get saleInfo;
}

class SaleVM extends SaleViewModel {
  SaleVM(this.infoService, this.saleInfo);

  final InfoService infoService;
  final SaleInfo saleInfo;

  @override
  void routingDidPush() {
    super.routingDidPush();
    notifyListeners();
  }
}
