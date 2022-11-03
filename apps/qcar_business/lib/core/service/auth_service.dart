class AuthenticationService {
  AuthenticationService();

  Future<void> signOut() async {}

  Future<bool> signInAnon() async {
    return true;
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    return "Signed in";
  }
}
