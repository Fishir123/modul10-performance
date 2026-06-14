// Unit test untuk GetPostsUseCase (Modul 9 - Testing).
//
// Fitur yang dites: "get posts" (use case lapisan domain) hasil refactor Modul 8.
// Fokus: LOGIC, tanpa UI. Repository di-mock dengan mockito agar test tidak
// bergantung pada API asli / jaringan.
//
// Mock di-generate via build_runner:
//   flutter pub run build_runner build --delete-conflicting-outputs
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:mobile_app/domain/entities/post.dart';
import 'package:mobile_app/domain/repositories/post_repository.dart';
import 'package:mobile_app/domain/usecases/get_posts_usecase.dart';

// Minta mockito membuat MockPostRepository dari kontrak abstrak PostRepository.
import 'get_posts_usecase_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late MockPostRepository repository;
  late GetPostsUseCase usecase;

  setUp(() {
    repository = MockPostRepository();
    usecase = GetPostsUseCase(repository);
  });

  // ---- BAGIAN 4: SUCCESS CASE ----------------------------------------------
  test('GetPostsUseCase mengembalikan data saat sukses', () async {
    final dummy = PostsResult(
      posts: const [
        Post(id: 1, title: 'judul 1', body: 'isi 1'),
        Post(id: 2, title: 'judul 2', body: 'isi 2'),
      ],
      source: DataSource.network,
    );
    when(repository.getPosts()).thenAnswer((_) async => dummy);

    final result = await usecase.execute();

    expect(result.posts.length, 2);
    expect(result.posts.first.title, 'judul 1');
    expect(result.source, DataSource.network);
    // Pastikan use case benar-benar memanggil repository sekali.
    verify(repository.getPosts()).called(1);
  });

  // ---- BAGIAN 5: ERROR CASE ------------------------------------------------
  test('GetPostsUseCase melempar error saat repository gagal', () async {
    when(repository.getPosts()).thenThrow(Exception('gagal jaringan'));

    expect(() => usecase.execute(), throwsException);
    verify(repository.getPosts()).called(1);
  });

  // ---- BAGIAN 6: EDGE CASE -------------------------------------------------
  test('GetPostsUseCase mengembalikan list kosong tanpa error', () async {
    when(repository.getPosts()).thenAnswer(
      (_) async => const PostsResult(posts: [], source: DataSource.cache),
    );

    final result = await usecase.execute();

    expect(result.posts.isEmpty, true);
    expect(result.source, DataSource.cache);
  });
}
