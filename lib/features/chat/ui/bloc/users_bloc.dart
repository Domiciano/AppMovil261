import 'package:appmovil261/features/chat/domain/usecases/get_or_create_conversation_usecase.dart';
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
  final GetProfilesUsecase _profilesUsecase = GetProfilesUsecase();
  final GetOrCreateConversationUsecase _conversationUsecase =
      GetOrCreateConversationUsecase();

  UsersBloc() : super(UsersInitialState()) {
    on<LoadUsersEvent>(_load);
    on<SelectUserEvent>(_selectUser);
  }

  Future<void> _load(LoadUsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoadingState());
    try {
      final users = await _profilesUsecase.execute(event.currentUserId);
      emit(UsersLoadedState(users));
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }

  Future<void> _selectUser(
      SelectUserEvent event, Emitter<UsersState> emit) async {
    // Keep the current list state if possible, or just emit a temporary loading if needed.
    // However, since we want to navigate, we can emit a navigation state.
    try {
      final conversation = await _conversationUsecase.execute(
        event.currentUserId,
        event.otherUser.id,
      );
      emit(NavigateToChatState(conversation.id, event.otherUser.name));
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }
}
