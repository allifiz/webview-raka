# Panduan Agent — WebView Raka

## Tujuan
APK Android Flutter yang membuka website absensi Raka melalui WebView dan meneruskan izin kamera serta lokasi ke halaman web.

## Aturan kerja
- Baca `README.md`, `PROGRESS.md`, `TODO.md`, dan `docs/UAT.md` sebelum mengubah kode.
- Perubahan harus minimal dan fokus pada kebutuhan yang diminta. Jangan refactor bagian lain tanpa alasan langsung.
- Jangan hardcode URL produksi. URL aplikasi web selalu berasal dari `--dart-define=APP_URL=...`.
- Untuk fitur kamera/lokasi, ubah dua sisi bila diperlukan: izin Android dan callback WebView.
- Setelah perubahan, jalankan formatter, analyzer, dan test yang relevan; perbarui `PROGRESS.md` dan `TODO.md`.
- Jangan menandai UAT end-to-end lulus tanpa URL staging, device Android, dan bukti hasil uji.

## Dokumen
- `README.md`: instalasi dan menjalankan aplikasi.
- `ARCHITECTURE.md`: struktur serta batas tanggung jawab.
- `docs/UAT.md`: skenario penerimaan.
- `PROGRESS.md`: kondisi implementasi nyata.
- `TODO.md`: daftar kerja tersisa.
