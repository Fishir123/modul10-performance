import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/repositories/post_repository.dart' show DataSource;
import '../providers/post_provider.dart';
import '../widgets/post_item_card.dart';

/// Screen daftar Post dengan caching + offline fallback (Modul 6 Bagian 6 & 7).
///
/// Menampilkan indikator sumber data:
/// - "Online Data"  : data baru dari server
/// - "Cached Data"  : data dari cache lokal (saat request gagal)
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    // Muat data setelah frame pertama agar context provider siap.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostProvider>().loadPosts(),
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == LoadState.error) {
            return _ErrorView(
              message: provider.errorMessage ?? 'Terjadi kesalahan',
              onRetry: () => provider.loadPosts(),
            );
          }

          return Column(
            children: [
              _SourceBanner(
                source: provider.source,
                cachedAt: provider.cachedAt,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.loadPosts(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    itemCount: provider.posts.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppConstants.spacingS),
                    itemBuilder: (context, index) {
                      final post = provider.posts[index];
                      return PostItemCard(post: post);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Banner indikator sumber data (Online vs Cached).
class _SourceBanner extends StatelessWidget {
  const _SourceBanner({required this.source, this.cachedAt});

  final DataSource? source;
  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context) {
    if (source == null) return const SizedBox.shrink();

    final isCache = source == DataSource.cache;
    final color = isCache ? Colors.orange : Colors.green;
    final label = isCache ? 'Cached Data' : 'Online Data';
    final icon = isCache ? Icons.cloud_off : Icons.cloud_done;

    String subtitle = isCache
        ? 'Menampilkan data tersimpan (koneksi gagal)'
        : 'Data terbaru dari server';
    if (isCache && cachedAt != null) {
      subtitle = 'Disimpan: ${_formatTime(cachedAt!)}';
    }

    return Container(
      width: double.infinity,
      color: color.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppConstants.spacingS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.day)}/${two(t.month)}/${t.year} ${two(t.hour)}:${two(t.minute)}';
  }
}

/// Tampilan error saat online gagal dan cache kosong.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              'Gagal memuat data dan tidak ada cache.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppConstants.spacingM),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
