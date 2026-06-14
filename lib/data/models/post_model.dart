/// Model data Post (mengikuti struktur JSONPlaceholder).
///
/// Dipakai pada lapisan service, repository, dan UI. Menyediakan
/// (de)serialisasi JSON agar mudah disimpan ke cache lokal sebagai String.
class PostModel {
  const PostModel({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final String title;
  final String body;

  /// Membuat instance dari Map hasil decode JSON.
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      body: (json['body'] ?? '') as String,
    );
  }

  /// Mengubah instance menjadi Map agar bisa di-encode kembali ke JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
      };
}
