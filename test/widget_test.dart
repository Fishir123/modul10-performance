// Widget test alur Login -> Home (diperbarui untuk Modul 6).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_app/data/repositories/post_repository_impl.dart';
import 'package:mobile_app/data/services/post_service.dart';
import 'package:mobile_app/domain/usecases/get_posts_usecase.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/presentation/providers/post_provider.dart';
import 'package:mobile_app/presentation/providers/theme_provider.dart';

void main() {
  setUp(() {
    // Mock penyimpanan lokal agar shared_preferences bisa dipakai di test.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Login tampil lalu navigasi ke Home setelah Masuk',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (_) => PostProvider(
              getPostsUseCase: GetPostsUseCase(
                PostRepositoryImpl(postService: PostService()),
              ),
            ),
          ),
        ],
        child: const MyApp(isLoggedIn: false),
      ),
    );

    // Layar awal: Login.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Masuk'), findsWidgets);

    // Isi form lalu tekan Masuk.
    await tester.enterText(find.byType(TextFormField).first, 'a@b.com');
    await tester.enterText(find.byType(TextFormField).last, 'secret');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    // Sekarang di Home.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
