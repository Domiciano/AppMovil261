import 'package:appmovil261/features/profile/domain/model/profile.dart';

abstract class ChatRepository {
  Future<List<Profile>> getProfiles(String currentUserId);
}
