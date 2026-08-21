# TODO

Status: `[x]` selesai, `[ ]` belum, `[-]` menunggu dependency eksternal.

## Fondasi
- [x] Buat source Flutter WebView.
- [x] Konfigurasi URL lewat `APP_URL`.
- [x] Tambahkan penanganan kamera dan geolocation WebView.
- [x] Tambahkan error state, reload, dan tombol kembali WebView.
- [x] Buat dokumentasi setup, arsitektur, dan UAT.

## Menunggu setup lokal
- [ ] Jalankan `flutter create --platforms=android .` untuk membangkitkan host Android.
- [ ] Tambahkan permission Android sesuai README.
- [ ] Jalankan `flutter pub get`, format, analyzer, dan test.
- [ ] Jalankan di device Android fisik.
- [-] Tentukan URL staging Laravel yang sudah HTTPS.
- [-] Web developer menyelesaikan capture kamera di halaman Laravel (`getUserMedia` + upload).
- [-] Jalankan seluruh UAT dengan akun dan Wi-Fi kantor uji.
- [ ] Generate signed release AAB/APK.
