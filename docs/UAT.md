# UAT — WebView Raka

## Prasyarat
- APK debug/release sudah terpasang pada Android fisik.
- `APP_URL` mengarah ke Laravel staging ber-HTTPS.
- Akun admin dan karyawan uji tersedia.
- Ada Wi-Fi kantor uji, GPS aktif, dan izin kamera/lokasi belum atau sudah disiapkan sesuai kasus.
- Website Laravel sudah memiliki capture kamera yang mengirim file `image`.

## Bukti setiap kasus
Catat build version, perangkat/Android version, URL staging, waktu, hasil aktual, screenshot/video, dan request/response yang relevan.

| ID | Tipe | Skenario | Langkah ringkas | Hasil yang diharapkan |
|---|---|---|---|---|
| UAT-01 | Positif | Launch pertama | Buka APK, izinkan kamera dan lokasi | Halaman login employee terbuka tanpa error |
| UAT-02 | Positif | Login valid | Login akun employee valid | Masuk dashboard employee |
| UAT-03 | Negatif | Login invalid | Isi password salah | Pesan gagal dari Laravel tampil, tidak login |
| UAT-04 | Negatif | Kamera ditolak | Tolak izin kamera, mulai absen | Website/APK menampilkan kegagalan kamera; absensi tidak terkirim |
| UAT-05 | Negatif | Lokasi ditolak | Tolak izin lokasi, mulai absen | Website menampilkan kegagalan lokasi; absensi tidak terkirim |
| UAT-06 | Positif | Presensi hadir valid | Wi-Fi kantor, GPS dalam radius, ambil foto baru, kirim | Laravel menyimpan satu log absensi dengan foto, GPS, waktu, dan IP |
| UAT-07 | Negatif | Bukan Wi-Fi kantor | Pakai data seluler/Wi-Fi lain, presensi Hadir | Backend menolak berdasarkan IP kantor |
| UAT-08 | Negatif | Di luar radius | Wi-Fi kantor tetapi GPS di luar radius (uji legal/aman) | Backend menolak berdasarkan radius |
| UAT-09 | Negatif | Foto galeri/manipulasi | Coba kirim berkas selain capture kamera | Hasil mengikuti kebijakan Laravel; bila belum terkunci, catat sebagai temuan backend |
| UAT-10 | Negatif | Tanpa koneksi | Matikan internet lalu buka/reload | Halaman error APK dan tombol Coba lagi tampil |
| UAT-11 | Positif | Tombol back | Navigasi halaman internal lalu tekan back Android | Kembali di WebView sebelum menutup aplikasi |
| UAT-12 | Positif | Link eksternal | Buka link tel/mailto/luar domain | Dibuka oleh aplikasi sistem, WebView tidak crash |
| UAT-13 | Regresi | Satu aksi dua kali | Kirim presensi sama dua kali | Laravel menolak log duplikat |
| UAT-14 | Regresi | Siklus lengkap | Check-in → break-in → break-out → check-out | Semua urutan Laravel berjalan dan tersimpan benar |

## Kriteria lulus
- Semua kasus positif lulus.
- Semua kasus negatif ditolak secara aman dan memiliki pesan yang dapat dipahami.
- Tidak ada crash/blank screen.
- UAT-06 sampai UAT-14 divalidasi terhadap database/log Laravel oleh tim web.
