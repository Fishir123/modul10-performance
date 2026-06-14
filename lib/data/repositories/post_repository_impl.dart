import 'dart:convert';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../../core/storage/local_storage.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

/// Implementasi konkret [PostRepository] (kontrak domain) di lapisan data.
///
/// Menggabungkan data API ([PostService]) dengan cache lokal ([LocalStorage]),
/// lalu memetakan `PostModel` (data) menjadi `Post` (entity domain).
///
/// Strategi:
/// - request API berhasil  -> simpan ke cache, sumber = network
/// - request API gagal      -> fallback ke cache bila ada, sumber = cache
/// - gagal & cache kosong   -> lempar ulang error (rethrow)
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({required this.postService});

  final PostService postService;

  /// Pemetaan model data -> entity domain (memutus ketergantungan UI ke model).
  Post _toEntity(PostModel m) => Post(id: m.id, title: m.title, body: m.body);

  @override
  Future<PostsResult> getPosts() async {
    try {
      final models = await postService.fetchPosts();

      // Simpan response (sebagai String JSON) ke cache lokal.
      final jsonString = jsonEncode(
        models.map((post) => post.toJson()).toList(),
      );
      await LocalStorage.saveCachedPosts(jsonString);

      return PostsResult(
        posts: models.map(_toEntity).toList(),
        source: DataSource.network,
      );
    } catch (e) {
      // Online gagal -> coba fallback ke cache lokal.
      final cachedData = await LocalStorage.getCachedPosts();
      if (cachedData != null) {
        final List<dynamic> jsonData = jsonDecode(cachedData) as List<dynamic>;
        final models = jsonData
            .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
            .toList();
        final cachedAt = await LocalStorage.getCachedAt();
        return PostsResult(
          posts: models.map(_toEntity).toList(),
          source: DataSource.cache,
          cachedAt: cachedAt,
        );
      }
      // Tidak ada cache sama sekali -> teruskan error ke pemanggil.
      rethrow;
    }
  }
}
