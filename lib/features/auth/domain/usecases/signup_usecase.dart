import 'package:appmovil261/features/auth/data/repo/auth_repo_impl.dart';
import 'package:appmovil261/features/auth/domain/repo/auth_repo.dart';
import 'package:appmovil261/features/profile/data/repository/profile_repository_impl.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';
import 'package:appmovil261/features/profile/domain/repository/profile_repository.dart';

class SignupUsecase {
  AuthRepo authRepo = AuthRepoImpl();
  ProfileRepository profileRepo = ProfileRepositoryImpl();

  Future<void> execute(String name, String email, String password) async {
    String id = await authRepo.signup(
      email,
      password,
    ); // Que debe entregar esta linea
    print(id);
    //Para poder hacer esta
    await profileRepo.saveProfile(Profile(id: id, name: name, email: email));
  }
}
