# Progress

Terakhir diperbarui: 2026-08-21

## Kondisi saat ini
Fondasi Flutter WebView sudah dibuat di repository:
- URL website memakai `--dart-define=APP_URL=...`; URL produksi tidak dihardcode.
- Izin kamera dan lokasi diminta di Flutter, lalu diteruskan saat WebView meminta kamera/geolocation.
- Ada loading bar, halaman gagal koneksi, retry, navigasi back, dan pembukaan link eksternal.
- Test unit dasar untuk konfigurasi URL tersedia.
- UAT plan sudah disiapkan di `docs/UAT.md`.

## Belum diverifikasi
Environment kerja ini belum memiliki Flutter/Android SDK dan belum ada URL staging Laravel HTTPS. Karena itu build APK, analyzer, test Flutter, dan UAT device belum boleh dinyatakan lulus.

## Next action
Di mesin pengembangan, ikuti README bagian **Bootstrap** lalu jalankan UAT dari awal menggunakan device Android yang tersambung Wi-Fi kantor.
