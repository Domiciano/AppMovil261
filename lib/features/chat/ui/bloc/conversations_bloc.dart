import 'package:appmovil261/features/chat/data/repository/chat_repository_impl.dart';
import 'package:appmovil261/features/chat/data/sources/chat_data_source.dart';
import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ConversationsEvent {}

class LoadConversationsEvent extends ConversationsEvent {
  final String currentUserId;
  LoadConversationsEvent(this.currentUserId);
}

// States
abstract class ConversationsState {}

class ConversationsInitialState extends ConversationsState {}

class ConversationsLoadingState extends ConversationsState {}

class ConversationsLoadedState extends ConversationsState {
  final List<Conversation> conversations;
  ConversationsLoadedState(this.conversations);
}

class ConversationsErrorState extends ConversationsState {
  final String message;
  ConversationsErrorState(this.message);
}

// BLoC
class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final GetConversationsUsecase _usecase = GetConversationsUsecase(
    ChatRepositoryImpl(ChatDataSource()),
  );

  ConversationsBloc() : super(ConversationsInitialState()) {
    on<LoadConversationsEvent>(_load);
  }

  Future<void> _load(
      LoadConversationsEvent event, Emitter<ConversationsState> emit) async {
    emit(ConversationsLoadingState());
    try {
      final list = await _usecase.execute(event.currentUserId);
      emit(ConversationsLoadedState(list));
    } catch (e) {
      emit(ConversationsErrorState(e.toString()));
    }
  }
}
