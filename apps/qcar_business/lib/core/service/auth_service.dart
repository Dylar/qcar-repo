import 'package:qcar_business/core/models/dealer_info.dart';
import 'package:qcar_business/core/models/seller_info.dart';

class AuthenticationService {
  AuthenticationService();

  SellerInfo? _loggedInUser = SellerInfo(dealer: "Autohaus", name: "Maxi");
  SellerInfo get currentUser => _loggedInUser!;

  DealerInfo? _loggedInDealer =
      DealerInfo(name: "Autohaus", address: "Hamburg");
  DealerInfo get currentDealer => _loggedInDealer!;

  Future<void> logout() async {
    _loggedInUser = null;
  }

  Future<bool> isDealerLoggedIn() async => _loggedInDealer != null;
  Future<bool> isUserLoggedIn() async => _loggedInUser != null;

  Future<void> login(SellerInfo user) async {
    _loggedInUser = user;
  }
}
