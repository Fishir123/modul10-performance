import 'package:flutter/material.dart';

/// Tema terpusat aplikasi.
///
/// Semua konfigurasi warna/typography didefinisikan di sini supaya konsisten
/// dan mudah diganti tanpa menyentuh kode UI.
class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFF2C5AA0);

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      );
}
