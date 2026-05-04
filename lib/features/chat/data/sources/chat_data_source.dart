import 'package:appmovil261/features/chat/domain/models/conversation.dart';
import 'package:appmovil261/features/chat/domain/models/message.dart';
import 'package:appmovil261/features/profile/domain/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatDataSource {
  final _client = Supabase.instance.client;

  Future<List<Profile>> getProfiles(String currentUserId) async {
    final response = await _client
        .from('profiles')
        .select()
        .neq('id', currentUserId)
        .order('name');
    return response.map((e) => Profile.fromJson(e)).toList();
  }

  Future<List<Conversation>> getConversations(String currentUserId) async {
    final response = await _client
        .from('conversations')
        .select('*, profile1:profiles!profile1_id(name), profile2:profiles!profile2_id(name)')
        .or('profile1_id.eq.$currentUserId,profile2_id.eq.$currentUserId')
        .order('created_at', ascending: false);

    return response
        .map((e) => Conversation.fromJson(e, currentUserId))
        .toList();
  }

  Future<Conversation> getOrCreateConversation(
    String currentUserId,
    String otherUserId,
  ) async {
    // Busca si ya existe la conversación en cualquier dirección
    final existing = await _client
        .from('conversations')
        .select()
        .or('and(profile1_id.eq.$currentUserId,profile2_id.eq.$otherUserId),and(profile1_id.eq.$otherUserId,profile2_id.eq.$currentUserId)')
        .maybeSingle();

    if (existing != null) {
      return Conversation.fromJson(existing, currentUserId);
    }

    final created = await _client
        .from('conversations')
        .insert({'profile1_id': currentUserId, 'profile2_id': otherUserId})
        .select()
        .single();

    return Conversation.fromJson(created, currentUserId);
  }

  Future<void> sendMessage(Message message) async {
    await _client.from('messages').insert(message.toJson());
  }

  // Realtime: escucha nuevos mensajes de la conversación
  Stream<List<Message>> watchMessages(String conversationId) {
    // Carga inicial + actualizaciones en tiempo real con StreamController
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((rows) => rows.map(Message.fromJson).toList());
  }
}
