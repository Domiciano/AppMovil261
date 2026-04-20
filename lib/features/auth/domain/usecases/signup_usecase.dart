import 'package:appmovil261/features/auth/data/repo/auth_repo_impl.dart';
import 'package:appmovil261/features/auth/domain/repo/auth_repo.dart';

class SignupUsecase {
  AuthRepo repo = AuthRepoImpl();

  Future<void> execute(String email, String password) async {
    await repo.signup(email, password);
  }
}
