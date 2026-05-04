import 'package:appmovil261/features/chat/domain/usecases/get_profiles_usecase.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class UsersEvent {}

class LoadUsersEvent extends UsersEvent {
  final String currentUserId;
  LoadUsersEvent(this.currentUserId);
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

// BLoC
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetProfilesUsecase _usecase = GetProfilesUsecase();

  UsersBloc() : super(UsersInitialState()) {
    on<LoadUsersEvent>(_load);
  }

  Future<void> _load(LoadUsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoadingState());
    try {
      final users = await _usecase.execute(event.currentUserId);
      emit(UsersLoadedState(users));
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }
}
