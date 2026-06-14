import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

/// Service jaringan: bertanggung jawab murni mengambil data dari API.
///
/// Tidak tahu-menahu soal cache. Pemisahan ini membuat logika offline
/// terpusat di repository (lihat [PostRepository]).
class PostService {
  PostService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Ambil daftar post dari API. Melempar exception bila gagal/timeout.
  Future<List<PostModel>> fetchPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await _client.get(uri).timeout(
          const Duration(seconds: 10),
        );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (HTTP ${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    // Batasi 20 item agar contoh ringan.
    return data
        .take(20)
        .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
