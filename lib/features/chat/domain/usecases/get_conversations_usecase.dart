import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';

class GetConversationsUsecase {
  final ChatRepository _repository;
  GetConversationsUsecase(this._repository);

  Future<List<Conversation>> execute(String currentUserId) {
    return _repository.getConversations(currentUserId);
  }
}
