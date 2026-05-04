import 'package:appmovil261/features/chat/data/repository/chat_repository_impl.dart';
import 'package:appmovil261/features/chat/data/sources/chat_data_source.dart';
import 'package:appmovil261/features/chat/domain/usecases/get_or_create_conversation_usecase.dart';
import 'package:appmovil261/features/chat/ui/bloc/users_bloc.dart';
import 'package:appmovil261/features/chat/ui/pages/chat_page.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;

    return BlocProvider(
      create: (_) => UsersBloc()..add(LoadUsersEvent(currentUserId)),
      child: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UsersErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is UsersLoadedState) {
            if (state.users.isEmpty) {
              return const Center(child: Text('No hay otros usuarios aún'));
            }
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return _UserTile(user: user, currentUserId: currentUserId);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _UserTile extends StatefulWidget {
  final Profile user;
  final String currentUserId;

  const _UserTile({required this.user, required this.currentUserId});

  @override
  State<_UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<_UserTile> {
  bool _loading = false;

  Future<void> _openChat() async {
    setState(() => _loading = true);
    try {
      final usecase = GetOrCreateConversationUsecase(
        ChatRepositoryImpl(ChatDataSource()),
      );
      final conversation = await usecase.execute(
        widget.currentUserId,
        widget.user.id,
      );
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(
              conversationId: conversation.id,
              otherUserName: widget.user.name,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.user.name.isNotEmpty
        ? widget.user.name[0].toUpperCase()
        : '?';

    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(widget.user.name),
      subtitle: Text(widget.user.email),
      trailing: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: _loading ? null : _openChat,
    );
  }
}
