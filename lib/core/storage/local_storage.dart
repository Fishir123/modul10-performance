import 'package:shared_preferences/shared_preferences.dart';

/// Helper terpusat untuk akses penyimpanan lokal key-value
/// (shared_preferences). Sesuai Modul 6 Bagian 4 & 6.
///
/// Semua key didefinisikan sebagai konstanta agar tidak salah ketik dan
/// mudah dipelihara di satu tempat.
class LocalStorage {
  LocalStorage._();

  static const String _kUsername = 'username';
  static const String _kIsLoggedIn = 'is_logged_in';
  static const String _kDarkMode = 'dark_mode';
  static const String _kCachedPosts = 'cached_posts';
  static const String _kCachedAt = 'cached_at';

  // --- Data sederhana: username & status login ---

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsername, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUsername);
  }

  static Future<void> saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsLoggedIn, status);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsLoggedIn) ?? false;
  }

  // --- Preferensi tema (Tugas Mandiri: dark mode flag) ---

  static Future<void> saveDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, enabled);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kDarkMode) ?? false;
  }

  // --- Cache response API (Bagian 6) ---

  /// Simpan response JSON (sudah berupa String) + waktu cache.
  static Future<void> saveCachedPosts(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCachedPosts, jsonString);
    await prefs.setString(_kCachedAt, DateTime.now().toIso8601String());
  }

  static Future<String?> getCachedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCachedPosts);
  }

  /// Waktu terakhir cache diperbarui (untuk ditampilkan di UI).
  static Future<DateTime?> getCachedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCachedAt);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  // --- Logout & reset ---

  /// Hapus status login + username (Tugas Mandiri: tombol Logout).
  /// Sengaja TIDAK menghapus cache & preferensi tema.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kIsLoggedIn);
    await prefs.remove(_kUsername);
  }

  /// Hapus seluruh data lokal.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
