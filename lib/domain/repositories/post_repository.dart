import '../entities/post.dart';

/// Sumber data hasil pengambilan: dari jaringan atau dari cache lokal.
///
/// Dipindah ke domain agar lapisan presentation tidak perlu meng-import
/// apa pun dari lapisan data (sebelumnya `DataSource` ada di data/).
enum DataSource { network, cache }

/// Pembungkus hasil use case: daftar post + asal data + kapan cache dibuat.
class PostsResult {
  const PostsResult({
    required this.posts,
    required this.source,
    this.cachedAt,
  });

  final List<Post> posts;
  final DataSource source;
  final DateTime? cachedAt;
}

/// Kontrak (abstraksi) repository pada lapisan domain.
///
/// Domain hanya mendefinisikan "apa" yang dibutuhkan, bukan "bagaimana"
/// implementasinya. Lapisan data yang menyediakan implementasi konkret.
/// Inilah inti Dependency Inversion: domain tidak bergantung pada data.
abstract class PostRepository {
  Future<PostsResult> getPosts();
}
