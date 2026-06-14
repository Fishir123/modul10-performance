# mobile_app — Modul 9: Testing (Unit Test + Basic UI Test)

Menambah testing pada fitur **get posts** (use case `GetPostsUseCase`) hasil
refactor clean architecture Modul 8.

## Test yang ditambahkan

`test/get_posts_usecase_test.dart` — 3 unit test (repository di-mock mockito):
- Success: repo kembalikan data → use case kembalikan data
- Error: repo melempar Exception → use case meneruskan error
- Edge: repo kembalikan list kosong → aman, tanpa error

`test/login_ui_test.dart` — 1 basic UI test (bonus): Login screen menampilkan
tombol Masuk + field input.

## Menjalankan test

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generate mock
flutter test                                                # semua test PASS
```

## Kenapa mocking

Repository asli memanggil API + cache. Saat test diganti `MockPostRepository`
agar hasilnya bisa diatur (sukses/gagal/kosong), test cepat, deterministik, dan
tidak butuh jaringan.

## Catatan

Project lanjutan dari Modul 8 (clean architecture), bukan project baru.
Layer domain (UseCase + Repository abstrak) membuat logic mudah diuji terisolasi.
