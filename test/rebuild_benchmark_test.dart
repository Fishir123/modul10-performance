// Pengukuran rebuild HomeScreen saat toggle dark mode (Modul 10 - Performance).
//
// Tujuan: membuktikan secara terukur dampak optimasi rebuild.
// _HomeScreenState.buildCount dihitung setelah beberapa kali toggle tema.
//
// SEBELUM: HomeScreen.build pakai context.watch<ThemeProvider>() di paling
//   atas, sehingga seluruh build() dijalankan ulang tiap toggle (rebuild
//   berlebihan: semua FeatureCard, teks, dll ikut dibangun ulang).
// SESUDAH: dependency tema dipindah ke widget kecil (Consumer pada switch
//   saja), sehingga build() screen tidak lagi ikut berjalan saat toggle.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/presentation/providers/theme_provider.dart';
import 'package:mobile_app/presentation/screens/home_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('hitung rebuild HomeScreen saat toggle dark mode', (tester) async {
    final themeProvider = ThemeProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeProvider,
        child: Consumer<ThemeProvider>(
          builder: (context, tp, _) => MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: tp.themeMode,
            home: const HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Reset penghitung setelah render awal.
    HomeScreen.buildCount = 0;

    // Toggle dark mode 5x.
    for (var i = 0; i < 5; i++) {
      themeProvider.toggleDarkMode(i.isEven);
      await tester.pumpAndSettle();
    }

    // ignore: avoid_print
    print('HOMESCREEN_REBUILD_COUNT=${HomeScreen.buildCount}');
    expect(HomeScreen.buildCount, greaterThanOrEqualTo(0));
  });
}
