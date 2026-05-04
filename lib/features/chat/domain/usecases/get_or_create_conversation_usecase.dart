import 'package:appmovil261/features/chat/data/repository/chat_repository_impl.dart';
import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';

class GetOrCreateConversationUsecase {
  final ChatRepository _repository = ChatRepositoryImpl();

  Future<Conversation> execute(String currentUserId, String otherUserId) {
    return _repository.getOrCreateConversation(currentUserId, otherUserId);
  }
}
