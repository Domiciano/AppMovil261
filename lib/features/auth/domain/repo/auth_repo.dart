abstract class AuthRepo {
  Future<void> signup(String email, String pass);
  Future<void> login(String email, String pass);
}
