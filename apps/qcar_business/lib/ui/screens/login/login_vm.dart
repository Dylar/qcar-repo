import 'dart:async';

import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/ui/notify/snackbars.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';
import 'package:qcar_shared/network_service.dart';

abstract class LoginViewModel extends ViewModel {
  List<SellerInfo> get sellers;

  Future<void> dealerSelected(String name);
  Future<void> userSelected(SellerInfo value);
}

class LoginVM extends LoginViewModel {
  LoginVM(this.authService, this.infoService);

  AuthenticationService authService;
  InfoService infoService;

  List<SellerInfo> sellers = [];

  @override
  Future init() async {
    if (await authService.isDealerLoggedIn()) {
      sellers = await infoService.getSeller(authService.currentDealer);
    }
  }

  @override
  Future<void> dealerSelected(String name) async {
    final status = await infoService.loadDealer(name);
    if (status == ResponseStatus.NOT_FOUND) {
      showSnackBar((ctx) => showNoDealerFoundSnackBar(ctx, name));
      return;
    }
    final dealer = infoService.getDealer();
    await authService.loginDealer(dealer);
    await infoService.loadDealerInfos(dealer);
    sellers = await infoService.getSeller(dealer);
    print("dealer: ${dealer.name}");
    print("SELLERS: ${sellers.length}");
    notifyListeners();
  }

  @override
  Future<void> userSelected(SellerInfo user) async {
    await authService.loginSeller(user);
    navigateTo(HomePage.popAndPush());
  }
}
