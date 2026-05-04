import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository _repository;
  SendMessageUsecase(this._repository);

  Future<void> execute(Message message) {
    return _repository.sendMessage(message);
  }
}
