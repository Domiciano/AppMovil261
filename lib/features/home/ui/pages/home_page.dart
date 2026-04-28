import 'package:appmovil261/features/post/ui/bloc/posts_list_bloc.dart';
import 'package:appmovil261/features/post/ui/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostsListBloc()..add(PostsListFetchEvent()),
      child: BlocBuilder<PostsListBloc, PostsListState>(
        builder: (context, state) {
          if (state is PostsListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostsListErrorState) {
            return Center(child: Text(state.message));
          }
          if (state is PostsListLoadedState) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('No hay posts aún'));
            }
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) =>
                  PostCard(post: state.posts[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
