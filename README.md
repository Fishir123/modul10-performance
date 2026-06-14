# mobile_app — Modul 10: Performance & Optimization

Analisis & optimasi performa pada project sendiri (lanjutan Modul 9).
Screen: HomeScreen & PostsScreen.

## Masalah → Solusi

1. Rebuild berlebihan (HomeScreen)
   - Sebelum: `context.watch<ThemeProvider>()` di `build()` root → seluruh
     screen rebuild tiap toggle dark mode.
   - Sesudah: toggle dipindah ke widget kecil `_DarkModeCard`
     (`Consumer<ThemeProvider>`) → hanya kartu switch yang rebuild.

2. Widget belum dipisah (PostsScreen)
   - Sebelum: item list (Card+ListTile) ditulis inline di `itemBuilder`.
   - Sesudah: dipindah ke `widgets/post_item_card.dart` (`PostItemCard`).

## Hasil terukur

`test/rebuild_benchmark_test.dart` menghitung rebuild HomeScreen saat 5x toggle:

| Kondisi | Rebuild |
|---------|---------|
| Sebelum | 15 |
| Sesudah | 10 (-33%) |

Sisa 10 = rebuild wajar dari `Theme.of` (inherited widget), bukan pemborosan.

## Menjalankan

```bash
flutter pub get
flutter test      # 10 test PASS (termasuk benchmark rebuild)
flutter run
```

## Catatan

ListView builder (lazy loading) & logic di repository sudah ada sejak Modul 6/8,
jadi optimasi yang tersisa difokuskan ke rebuild root + pemisahan widget.
Penghitung `buildCount` hanya alat observasi, tidak mengubah perilaku app.
