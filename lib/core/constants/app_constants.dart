/// App-wide constant values (nama app, spacing, dsb).
///
/// Letakkan nilai statis yang dipakai lintas fitur di sini agar mudah diubah
/// di satu tempat (single source of truth).
class AppConstants {
  AppConstants._(); // mencegah instansiasi

  static const String appName = 'Mobile App';
  static const String homeTitle = 'Home';

  // Spacing standar (mengikuti kelipatan 8 - Material guideline).
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
}
