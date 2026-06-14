import '../repositories/post_repository.dart';

/// Use case: mengambil daftar post.
///
/// Membungkus satu aksi bisnis tunggal. Provider memanggil use case ini,
/// bukan repository langsung, sehingga aturan bisnis terpusat di domain dan
/// mudah diuji/diganti tanpa menyentuh UI.
class GetPostsUseCase {
  const GetPostsUseCase(this.repository);

  final PostRepository repository;

  Future<PostsResult> execute() {
    return repository.getPosts();
  }
}
