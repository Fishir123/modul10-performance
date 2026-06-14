// Basic UI Test (Modul 9 - Bagian 8, bonus opsional).
//
// Hanya memeriksa elemen UI sederhana muncul. Logic inti tetap diuji di
// get_posts_usecase_test.dart (tanpa UI).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/presentation/screens/login_screen.dart';

void main() {
  testWidgets('Login screen menampilkan tombol Masuk dan field input',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );

    // Judul "Login" muncul.
    expect(find.text('Login'), findsWidgets);
    // Tombol "Masuk" ada.
    expect(find.widgetWithText(FilledButton, 'Masuk'), findsOneWidget);
    // Dua field input (email & password).
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
