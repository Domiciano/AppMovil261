import 'package:appmovil261/features/chat/data/sources/chat_data_source.dart';
import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource = ChatDataSource();

  @override
  Future<List<Profile>> getProfiles() {
    return _dataSource.getProfiles();
  }

  @override
  Future<Conversation> getOrCreateConversation(
    String currentUserId,
    String otherUserId,
  ) {
    return _dataSource.getOrCreateConversation(currentUserId, otherUserId);
  }

  @override
  Future<void> sendMessage(Message message) {
    return _dataSource.sendMessage(message);
  }
}
