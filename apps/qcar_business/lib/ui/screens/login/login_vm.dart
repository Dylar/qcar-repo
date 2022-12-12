import 'dart:async';

import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/core/service/auth_service.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';
import 'package:qcar_shared/core/app_viewmodel.dart';

abstract class LoginViewModel extends ViewModel {
  List<SellerInfo> get sellers;

  Future<void> userSelected(SellerInfo value);
}

class LoginVM extends LoginViewModel {
  LoginVM(this.authService, this.infoService);

  AuthenticationService authService;
  InfoService infoService;

  List<SellerInfo> sellers = [];

  @override
  Future init() async {
    sellers = await infoService.getSeller();
  }

  @override
  Future<void> userSelected(SellerInfo user) async {
    await authService.signIn(user);
    navigateTo(HomePage.popAndPush());
  }
}
