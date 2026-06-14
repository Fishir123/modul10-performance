import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';

/// Kartu item satu Post pada daftar Artikel.
///
/// Fix performa Modul 10 (Bagian 5 - pisahkan widget): dipindah keluar dari
/// `itemBuilder` PostsScreen agar:
/// - widget modular & mudah dibaca/maintain,
/// - bisa `const`-kan bagian yang tetap,
/// - rebuild item terisolasi (tidak menyeret logika screen).
class PostItemCard extends StatelessWidget {
  const PostItemCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${post.id}')),
        title: Text(
          post.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          post.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
