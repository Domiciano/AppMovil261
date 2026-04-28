import 'package:appmovil261/features/post/domain/models/post.dart';
import 'package:appmovil261/features/post/domain/usecases/fetch_posts_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class PostsListEvent {}

class PostsListFetchEvent extends PostsListEvent {}

// States
abstract class PostsListState {}

class PostsListInitialState extends PostsListState {}

class PostsListLoadingState extends PostsListState {}

class PostsListLoadedState extends PostsListState {
  final List<Post> posts;
  PostsListLoadedState(this.posts);
}

class PostsListErrorState extends PostsListState {
  final String message;
  PostsListErrorState(this.message);
}

// BLoC
class PostsListBloc extends Bloc<PostsListEvent, PostsListState> {
  final FetchPostsUsecase _usecase = FetchPostsUsecase();

  PostsListBloc() : super(PostsListInitialState()) {
    on<PostsListFetchEvent>(_fetchPosts);
  }

  Future<void> _fetchPosts(PostsListFetchEvent event, Emitter<PostsListState> emit) async {
    emit(PostsListLoadingState());
    try {
      final posts = await _usecase.execute();
      emit(PostsListLoadedState(posts));
    } catch (e) {
      emit(PostsListErrorState(e.toString()));
    }
  }
}
