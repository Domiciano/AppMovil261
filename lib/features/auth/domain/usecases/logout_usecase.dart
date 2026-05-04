import 'package:appmovil261/features/auth/data/repo/auth_repo_impl.dart';
import 'package:appmovil261/features/auth/domain/repo/auth_repo.dart';

class LogoutUsecase {
  AuthRepo repo = AuthRepoImpl();

  Future<void> execute() async {
    await repo.logout();
  }
}
