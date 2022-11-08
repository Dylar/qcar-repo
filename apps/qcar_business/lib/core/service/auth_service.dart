import 'package:qcar_business/core/models/seller_info.dart';

class AuthenticationService {
  AuthenticationService();

  SellerInfo? _loggedInUser;
  SellerInfo get currentUser => _loggedInUser!;

  Future<void> signOut() async {}

  Future<bool> isSignedIn() async {
    return _loggedInUser != null;
  }

  Future<void> signIn(SellerInfo user) async {
    _loggedInUser = user;
  }
}
