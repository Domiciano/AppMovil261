import 'dart:async';

import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:appmovil261/features/chat/domain/usecases/watch_messages_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ChatEvent {}

class SubscribeToMessagesEvent extends ChatEvent {
  final String conversationId;
  SubscribeToMessagesEvent(this.conversationId);
}

class SendMessageEvent extends ChatEvent {
  final String conversationId;
  final String senderId;
  final String content;
  SendMessageEvent({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });
}

class _MessagesUpdatedEvent extends ChatEvent {
  final List<Message> messages;
  _MessagesUpdatedEvent(this.messages);
}

// States
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Message> messages;
  ChatLoadedState(this.messages);
}

class ChatErrorState extends ChatState {
  final String message;
  ChatErrorState(this.message);
}

// BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _watchUsecase = WatchMessagesUsecase();
  final _sendUsecase = SendMessageUsecase();
  StreamSubscription<List<Message>>? _subscription;

  ChatBloc() : super(ChatInitialState()) {
    on<SubscribeToMessagesEvent>(_subscribe);
    on<_MessagesUpdatedEvent>(_onUpdated);
    on<SendMessageEvent>(_send);
  }

  void _subscribe(
      SubscribeToMessagesEvent event, Emitter<ChatState> emit) {
    emit(ChatLoadingState());
    _subscription?.cancel();
    // Realtime: cada vez que llega un cambio en la tabla, el stream emite
    _subscription = _watchUsecase.execute(event.conversationId).listen(
      (messages) => add(_MessagesUpdatedEvent(messages)),
      onError: (e) => add(_MessagesUpdatedEvent([])),
    );
  }

  void _onUpdated(_MessagesUpdatedEvent event, Emitter<ChatState> emit) {
    emit(ChatLoadedState(event.messages));
  }

  Future<void> _send(SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      final msg = Message(
        id: '',
        conversationId: event.conversationId,
        senderId: event.senderId,
        content: event.content,
        createdAt: DateTime.now(),
      );
      await _sendUsecase.execute(msg);
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
