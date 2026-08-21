# Arsitektur

## Batas aplikasi
Flutter hanya menjadi shell Android untuk website Laravel absensi. Aturan absensi, autentikasi, validasi IP kantor, GPS radius, dan penyimpanan foto tetap menjadi tanggung jawab backend Laravel.

## Alur
`Flutter APK → Android WebView → https://server/employee → Laravel`

1. Flutter meminta izin kamera dan lokasi Android.
2. WebView membuka URL dari `APP_URL`.
3. Ketika website meminta kamera/lokasi, callback WebView meneruskan izin bila izin Android sudah disetujui.
4. Foto dan koordinat dikirim dari halaman Laravel ke endpoint Laravel, bukan disimpan oleh Flutter.

## Berkas penting
- `lib/main.dart`: UI, permission Android/WebView, navigasi, error state.
- `lib/app_config.dart`: konfigurasi URL berbasis `--dart-define`.
- `test/app_config_test.dart`: test unit tanpa device.
- `docs/UAT.md`: test manual di device/emulator.

## Keamanan
- Produksi harus HTTPS agar kamera dan geolocation di web berjalan.
- Jangan menyimpan password, token, atau URL rahasia di source.
- APK tidak boleh melewati validasi server; WebView hanya menampilkan website.
