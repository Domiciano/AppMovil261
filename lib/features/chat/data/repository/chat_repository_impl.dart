import 'package:appmovil261/features/chat/data/sources/chat_data_source.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource = ChatDataSource();

  @override
  Future<List<Profile>> getProfiles(String currentUserId) {
    return _dataSource.getProfiles(currentUserId);
  }
}
