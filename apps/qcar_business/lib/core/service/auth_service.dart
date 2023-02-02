import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';

class AuthenticationService {
  AuthenticationService();

  SellerInfo? _loggedInSeller;
  SellerInfo get currentSeller => _loggedInSeller!;

  DealerInfo? _loggedInDealer;
  DealerInfo get currentDealer => _loggedInDealer!;

  Future<bool> isDealerLoggedIn() async => _loggedInDealer != null;
  Future<bool> isUserLoggedIn() async => _loggedInSeller != null;

  Future<void> loginDealer(DealerInfo dealer) async {
    _loggedInDealer = dealer;
  }

  Future<void> loginSeller(SellerInfo seller) async {
    _loggedInSeller = seller;
  }

  Future<void> logoutSeller() async {
    _loggedInSeller = null;
  }
}
