import 'dart:async';

import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:appmovil261/features/chat/domain/usecases/watch_messages_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
  SendMessageUsecase _sendMessageUsecase = SendMessageUsecase();
  WatchMessagesUsecase _watchMessagesUsecase = WatchMessagesUsecase();

  ChatBloc() : super(ChatInitialState()) {
    on<SubscribeToMessagesEvent>((event, emit) {
      _watchMessagesUsecase
          .execute(event.conversationId)
          .listen((messages) => add(_MessagesUpdatedEvent(messages)));
    });
    on<_MessagesUpdatedEvent>((event, emit) {
      emit(ChatLoadedState(event.messages));
    });
    on<SendMessageEvent>((event, emit) {
      _sendMessageUsecase.execute(
        Message(
          id: Uuid().v4(),
          conversationId: event.conversationId,
          senderId: event.senderId,
          content: event.content,
          createdAt: DateTime.now(),
        ),
      );
    });
  }
}
