import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';

class GetProfilesUsecase {
  final ChatRepository _repository;
  GetProfilesUsecase(this._repository);

  Future<List<Profile>> execute(String currentUserId) {
    return _repository.getProfiles(currentUserId);
  }
}
