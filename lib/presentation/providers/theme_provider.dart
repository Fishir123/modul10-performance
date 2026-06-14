import 'package:flutter/material.dart';
import '../../core/storage/local_storage.dart';

/// Provider preferensi tema (Tugas Mandiri: dark mode flag).
///
/// Nilai dark mode dipersistensi lewat [LocalStorage] sehingga pilihan user
/// tetap tersimpan meski aplikasi ditutup.
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Muat preferensi tema dari penyimpanan lokal saat aplikasi start.
  Future<void> load() async {
    _isDarkMode = await LocalStorage.getDarkMode();
    notifyListeners();
  }

  /// Ubah & simpan preferensi dark mode.
  Future<void> toggleDarkMode(bool enabled) async {
    _isDarkMode = enabled;
    await LocalStorage.saveDarkMode(enabled);
    notifyListeners();
  }
}
