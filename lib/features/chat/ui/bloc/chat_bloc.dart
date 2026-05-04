import 'dart:async';

import 'package:appmovil261/features/chat/domain/models/message.dart';
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
  ChatBloc() : super(ChatInitialState());
}
