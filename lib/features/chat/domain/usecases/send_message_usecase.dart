import 'package:appmovil261/features/chat/data/repository/chat_repository_impl.dart';
import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/chat/domain/repository/chat_repository.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';

class SendMessageUsecase {
  final ChatRepository _repository = ChatRepositoryImpl();

  Future<void> execute(Message message) {
    return _repository.sendMessage(message);
  }
}
