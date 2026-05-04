import 'package:appmovil261/features/chat/data/sources/chat_data_source.dart';
import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource;
  ChatRepositoryImpl(this._dataSource);

  @override
  Future<List<Profile>> getProfiles(String currentUserId) {
    return _dataSource.getProfiles(currentUserId);
  }

  @override
  Future<List<Conversation>> getConversations(String currentUserId) {
    return _dataSource.getConversations(currentUserId);
  }

  @override
  Future<Conversation> getOrCreateConversation(
      String currentUserId, String otherUserId) {
    return _dataSource.getOrCreateConversation(currentUserId, otherUserId);
  }

  @override
  Future<void> sendMessage(Message message) {
    return _dataSource.sendMessage(message);
  }

  @override
  Stream<List<Message>> watchMessages(String conversationId) {
    return _dataSource.watchMessages(conversationId);
  }
}
