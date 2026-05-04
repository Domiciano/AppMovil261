import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';

class GetOrCreateConversationUsecase {
  final ChatRepository _repository;
  GetOrCreateConversationUsecase(this._repository);

  Future<Conversation> execute(String currentUserId, String otherUserId) {
    return _repository.getOrCreateConversation(currentUserId, otherUserId);
  }
}
