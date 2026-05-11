import 'dart:io';

import 'package:appmovil261/features/chat/ui/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.otherUserName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _selectedImage = picked);
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;
    context.read<ChatBloc>().add(SendMessageEvent(
          conversationId: widget.conversationId,
          senderId: currentUserId,
          content: text,
        ));
    _controller.clear();
    setState(() => _selectedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc()
        ..add(SubscribeToMessagesEvent(widget.conversationId)),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.otherUserName)),
        body: Column(
          children: [
            Expanded(child: _MessageList()),
            if (_selectedImage != null)
              SizedBox(
                height: 80,
                width: double.infinity,
                child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
              ),
            _InputBar(
              controller: _controller,
              onSend: _send,
              onPickImage: _pickImage,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ChatErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is ChatLoadedState) {
          final messages = state.messages;
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg.senderId == currentUserId;
              return _MessageBubble(msg: msg, isMe: isMe);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final dynamic msg;
  final bool isMe;
  final String? imagePath;

  const _MessageBubble({required this.msg, required this.isMe, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              SizedBox(
                width: 200,
                height: 150,
                child: Image.file(File(imagePath!), fit: BoxFit.cover),
              ),
            Text(
              msg.content,
              style: TextStyle(
                color: isMe
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(BuildContext) onSend;
  final VoidCallback onPickImage;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              child: IconButton(
                icon: const Icon(Icons.photo_library_outlined),
                onPressed: onPickImage,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onSubmitted: (_) => onSend(context),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.send),
              onPressed: () => onSend(context),
            ),
          ],
        ),
      ),
    );
  }
}
