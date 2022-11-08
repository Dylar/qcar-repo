import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class HomeViewModel extends ViewModel {
  List<SellInfo> get sellInfos;
}

class HomeVM extends HomeViewModel {
  HomeVM(this.authService, this.infoService);

  final InfoService infoService;
  final AuthenticationService authService;

  @override
  List<SellInfo> get sellInfos =>
      infoService.getSellInfos(authService.currentUser);

  @override
  void routingDidPush() {
    super.routingDidPush();
    notifyListeners();
  }
}
