import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';

class WatchMessagesUsecase {
  final ChatRepository _repository;
  WatchMessagesUsecase(this._repository);

  Stream<List<Message>> execute(String conversationId) {
    return _repository.watchMessages(conversationId);
  }
}
