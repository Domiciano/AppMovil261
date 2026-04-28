import 'package:appmovil261/features/post/domain/models/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostDataSource {
  final _client = Supabase.instance.client;

  Future<void> createPost(Post post) async {
    await _client.from('posts').insert(post.toJson());
  }

  Future<List<Post>> fetchAllPosts() async {
    final response = await _client
        .from('posts')
        .select()
        .order('created_at', ascending: false);
    return response.map((e) => Post.fromJson(e)).toList();
  }
}
