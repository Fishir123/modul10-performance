// Golden test untuk menghasilkan bukti screenshot tiap layar (Modul 6).
// Jalankan: flutter test --update-goldens test/screenshots_test.dart
// PNG dihasilkan di folder evidence/ sebagai bukti laporan.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/data/repositories/post_repository_impl.dart';
import 'package:mobile_app/data/services/post_service.dart';
import 'package:mobile_app/domain/usecases/get_posts_usecase.dart';
import 'package:mobile_app/presentation/providers/post_provider.dart';
import 'package:mobile_app/presentation/providers/theme_provider.dart';
import 'package:mobile_app/presentation/screens/home_screen.dart';
import 'package:mobile_app/presentation/screens/login_screen.dart';
import 'package:mobile_app/presentation/screens/posts_screen.dart';

// Data dummy untuk response API pada test.
String _fakeJson() => jsonEncode(
      List.generate(
        5,
        (i) => {
          'id': i + 1,
          'title': 'Judul artikel contoh nomor ${i + 1}',
          'body': 'Isi ringkas artikel ke-${i + 1} untuk bukti screenshot.',
        },
      ),
    );

// Client yang selalu sukses (untuk skenario Online Data).
http.Client _okClient() =>
    MockClient((req) async => http.Response(_fakeJson(), 200));

// Client yang selalu gagal (untuk skenario Cached Data / offline).
http.Client _failClient() =>
    MockClient((req) async => throw Exception('Tidak ada koneksi'));

Widget _wrap(Widget child, {required PostProvider postProvider}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider.value(value: postProvider),
    ],
    child: MaterialApp(theme: AppTheme.light, home: child),
  );
}

// Muat font asli agar teks tidak dirender sebagai kotak (font default test
// 'Ahem' menggambar semua glyph sebagai kotak hitam).
Future<void> _loadFonts() async {
  const sans = '/usr/share/fonts/TTF/DejaVuSans.ttf';
  const bold = '/usr/share/fonts/TTF/DejaVuSans-Bold.ttf';
  for (final family in ['Roboto', 'DejaVu Sans', 'packages/cupertino_icons/CupertinoIcons']) {
    final loader = FontLoader(family);
    loader.addFont(File(sans).readAsBytes().then((b) => b.buffer.asByteData()));
    if (File(bold).existsSync()) {
      loader.addFont(
          File(bold).readAsBytes().then((b) => b.buffer.asByteData()));
    }
    await loader.load();
  }
  // Muat font ikon Material agar ikon tampil benar.
  final iconFont = File(
      '/home/faiqm/tools/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
  if (iconFont.existsSync()) {
    final loader = FontLoader('MaterialIcons')
      ..addFont(
          iconFont.readAsBytes().then((b) => b.buffer.asByteData()));
    await loader.load();
  }
}

void main() {
  setUpAll(() async {
    await _loadFonts();
  });

  setUp(() => SharedPreferences.setMockInitialValues({'username': 'a@b.com'}));

  testWidgets('bukti_1_login', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 760));
    await tester.pumpWidget(
      const MaterialApp(home: LoginScreen()),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(LoginScreen),
      matchesGoldenFile('../evidence/bukti_1_login.png'),
    );
  });

  testWidgets('bukti_2_home', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 760));
    final provider = PostProvider(
        getPostsUseCase: GetPostsUseCase(
            PostRepositoryImpl(postService: PostService())));
    await tester.pumpWidget(_wrap(const HomeScreen(), postProvider: provider));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('../evidence/bukti_2_home.png'),
    );
  });

  testWidgets('bukti_3_posts_online', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 760));
    final provider = PostProvider(
      getPostsUseCase: GetPostsUseCase(
        PostRepositoryImpl(postService: PostService(client: _okClient())),
      ),
    );
    await tester.pumpWidget(_wrap(const PostsScreen(), postProvider: provider));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(PostsScreen),
      matchesGoldenFile('../evidence/bukti_3_posts_online.png'),
    );
  });

  testWidgets('bukti_4_posts_cached', (tester) async {
    // Isi cache dulu lewat client sukses, lalu reload dengan client gagal.
    SharedPreferences.setMockInitialValues({});
    final okRepo =
        PostRepositoryImpl(postService: PostService(client: _okClient()));
    await okRepo.getPosts(); // menyimpan cache

    await tester.binding.setSurfaceSize(const Size(420, 760));
    final provider = PostProvider(
      getPostsUseCase: GetPostsUseCase(
        PostRepositoryImpl(postService: PostService(client: _failClient())),
      ),
    );
    await tester.pumpWidget(_wrap(const PostsScreen(), postProvider: provider));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(PostsScreen),
      matchesGoldenFile('../evidence/bukti_4_posts_cached.png'),
    );
  });
}
