import 'package:qcar_business/core/models/seller_info.dart';

class AuthenticationService {
  AuthenticationService();

  SellerInfo? currentUser;

  Future<void> signOut() async {}

  Future<bool> isSignedIn() async {
    return currentUser != null;
  }

  Future<void> signIn(SellerInfo user) async {
    currentUser = user;
  }
}
