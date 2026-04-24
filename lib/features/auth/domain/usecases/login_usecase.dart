import 'package:appmovil261/features/auth/data/repo/auth_repo_impl.dart';
import 'package:appmovil261/features/auth/domain/repo/auth_repo.dart';

class LoginUsecase {
  AuthRepo repo = AuthRepoImpl();

  Future<void> execute(String email, String password) async {
    await repo.login(email, password);
  }
}
