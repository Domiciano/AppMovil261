import 'package:appmovil261/features/chat/data/repository/chat_repository_impl.dart';
import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';

class GetConversationsUsecase {
  final ChatRepository _repository = ChatRepositoryImpl();

  Future<List<Conversation>> execute(String currentUserId) {
    return _repository.getConversations(currentUserId);
  }
}
