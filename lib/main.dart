import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/storage/local_storage.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/post_repository_impl.dart';
import 'data/services/post_service.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'presentation/providers/post_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';

Future<void> main() async {
  // Wajib sebelum memanggil API async (shared_preferences) di main().
  WidgetsFlutterBinding.ensureInitialized();

  // Muat preferensi tema & status login dari penyimpanan lokal.
  final themeProvider = ThemeProvider();
  await themeProvider.load();
  final isLoggedIn = await LocalStorage.getLoginStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(
          create: (_) => PostProvider(
            // Wiring clean architecture:
            // Provider -> UseCase -> Repository(domain) -> RepositoryImpl(data) -> Service
            getPostsUseCase: GetPostsUseCase(
              PostRepositoryImpl(postService: PostService()),
            ),
          ),
        ),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

/// Root aplikasi.
///
/// Tema mengikuti [ThemeProvider] (dipersistensi). Halaman awal ditentukan
/// oleh status login yang tersimpan lokal: bila sudah login langsung ke Home.
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
