import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/storage/local_storage.dart';
import '../providers/theme_provider.dart';
import '../widgets/feature_card.dart';
import 'detail_screen.dart';
import 'login_screen.dart';
import 'posts_screen.dart';

/// Home Screen (diperluas pada Modul 6).
///
/// Menampilkan username tersimpan, toggle dark mode (preferensi lokal),
/// akses ke daftar Artikel (caching/offline), dan tombol Logout.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await LocalStorage.getUsername();
    setState(() => _username = name ?? 'Pengguna');
  }

  void _openDetail(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          title: title,
          description: description,
          icon: icon,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    // Hapus status login lokal (Tugas Mandiri: tombol Logout).
    await LocalStorage.clearSession();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.homeTitle),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        children: [
          Text(
            'Halo, $_username',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            'Workshop Pemrograman Perangkat Bergerak - Sprint 1',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppConstants.spacingL),

          // Toggle dark mode (preferensi disimpan lokal).
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Mode Gelap'),
              subtitle: const Text('Preferensi disimpan secara lokal'),
              value: themeProvider.isDarkMode,
              onChanged: (v) => themeProvider.toggleDarkMode(v),
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),

          FeatureCard(
            icon: Icons.article_outlined,
            title: 'Artikel',
            subtitle: 'Data API dengan cache & mode offline',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostsScreen()),
            ),
          ),
          FeatureCard(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            subtitle: 'Ringkasan aktivitas aplikasi',
            onTap: () => _openDetail(
              context,
              title: 'Dashboard',
              description: 'Ringkasan aktivitas aplikasi ditampilkan di sini.',
              icon: Icons.dashboard_outlined,
            ),
          ),
          FeatureCard(
            icon: Icons.person_outline,
            title: 'Profil',
            subtitle: 'Kelola data pengguna',
            onTap: () => _openDetail(
              context,
              title: 'Profil',
              description: 'Halaman pengelolaan data pengguna.',
              icon: Icons.person_outline,
            ),
          ),
          FeatureCard(
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            subtitle: 'Konfigurasi aplikasi',
            onTap: () => _openDetail(
              context,
              title: 'Pengaturan',
              description: 'Atur preferensi dan konfigurasi aplikasi.',
              icon: Icons.settings_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
