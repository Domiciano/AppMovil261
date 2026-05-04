import 'package:appmovil261/features/post/ui/bloc/post_bloc.dart';
import 'package:appmovil261/features/post/ui/bloc/posts_list_bloc.dart';
import 'package:appmovil261/features/post/ui/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PostsListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PostsListBloc()..add(PostsListFetchEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _openCreateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider.value(
        value: _bloc,
        child: const _CreatePostModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocBuilder<PostsListBloc, PostsListState>(
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
                itemBuilder: (_, index) => PostCard(post: state.posts[index]),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton(
            onPressed: () => _openCreateModal(ctx),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class _CreatePostModal extends StatefulWidget {
  const _CreatePostModal();

  @override
  State<_CreatePostModal> createState() => _CreatePostModalState();
}

class _CreatePostModalState extends State<_CreatePostModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<PostBloc>().add(PostSubmitEvent(
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(),
      child: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostSuccessState) {
            context.read<PostsListBloc>().add(PostsListFetchEvent());
            Navigator.pop(context);
          } else if (state is PostErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PostLoadingState;
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nuevo Post',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Ingresa un título' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(labelText: 'Contenido'),
                    maxLines: 4,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Ingresa el contenido' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : () => _submit(context),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Publicar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
