/// Entitas Post pada lapisan domain.
///
/// Berbeda dari `PostModel` (lapisan data): entity ini murni objek bisnis,
/// tidak tahu soal JSON, API, atau cache. Domain tidak boleh bergantung pada
/// detail teknis lapisan data.
class Post {
  const Post({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final String title;
  final String body;
}
