import 'package:appmovil261/features/chat/domain/usecases/get_profiles_usecase.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class UsersEvent {}

class LoadUsersEvent extends UsersEvent {
  final String currentUserId;
  LoadUsersEvent(this.currentUserId);
}

class SelectUserEvent extends UsersEvent {
  final String currentUserId;
  final Profile otherUser;
  SelectUserEvent(this.currentUserId, this.otherUser);
}

// States
abstract class UsersState {}

class UsersInitialState extends UsersState {}

class UsersLoadingState extends UsersState {}

class UsersLoadedState extends UsersState {
  final List<Profile> users;
  UsersLoadedState(this.users);
}

class UsersErrorState extends UsersState {
  final String message;
  UsersErrorState(this.message);
}

class NavigateToChatState extends UsersState {
  final String conversationId;
  final String otherUserName;
  NavigateToChatState(this.conversationId, this.otherUserName);
}

// BLoC
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitialState()) {}

  Future<void> _load(LoadUsersEvent event, Emitter<UsersState> emit) async {}

  Future<void> _selectUser(
    SelectUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    //Crear conversación si no existe

    //Luego navegar hacia la pantalla por medio de evento
  }
}
