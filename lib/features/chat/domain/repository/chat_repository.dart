import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';

abstract class ChatRepository {
  Future<List<Profile>> getProfiles(String currentUserId);
  Future<List<Conversation>> getConversations(String currentUserId);
  Future<Conversation> getOrCreateConversation(String currentUserId, String otherUserId);
  Future<void> sendMessage(Message message);
  Stream<List<Message>> watchMessages(String conversationId);
}
