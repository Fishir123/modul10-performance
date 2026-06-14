import 'package:flutter/foundation.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart' show DataSource;
import '../../domain/usecases/get_posts_usecase.dart';

/// State sederhana untuk loading async.
enum LoadState { idle, loading, success, error }

/// Provider yang mengelola daftar post + indikator sumber data.
///
/// Clean architecture: provider memanggil [GetPostsUseCase] (lapisan domain),
/// BUKAN repository/service langsung. Provider hanya mengelola state UI.
class PostProvider extends ChangeNotifier {
  PostProvider({required this.getPostsUseCase});

  final GetPostsUseCase getPostsUseCase;

  LoadState _state = LoadState.idle;
  List<Post> _posts = const [];
  DataSource? _source;
  DateTime? _cachedAt;
  String? _errorMessage;

  LoadState get state => _state;
  List<Post> get posts => _posts;
  DataSource? get source => _source;
  DateTime? get cachedAt => _cachedAt;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == LoadState.loading;
  bool get isFromCache => _source == DataSource.cache;

  /// Ambil data lewat use case dan perbarui state.
  Future<void> loadPosts() async {
    _state = LoadState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getPostsUseCase.execute();
      _posts = result.posts;
      _source = result.source;
      _cachedAt = result.cachedAt;
      _state = LoadState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = LoadState.error;
    }
    notifyListeners();
  }
}
