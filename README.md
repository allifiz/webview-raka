# WebView Raka

APK Android berbasis Flutter untuk membuka website absensi Raka di dalam WebView. Aplikasi ini **bukan** backend absensi: login, validasi Wi-Fi/IP, GPS radius, kamera capture, dan penyimpanan absensi tetap berjalan di Laravel.

## Yang sudah disiapkan

- URL Laravel dikonfigurasi dengan `--dart-define=APP_URL=...`, bukan ditulis tetap di source.
- WebView mendukung JavaScript, kamera, geolocation, navigasi back, loading bar, retry saat gagal koneksi, dan link eksternal.
- Test unit dan workflow CI untuk format, analyzer, serta test.
- Dokumen arsitektur, progress, TODO, dan rencana UAT.

## Prasyarat

Gunakan Windows atau Linux; macOS tidak diperlukan karena targetnya hanya Android.

1. Install [Git](https://git-scm.com/downloads).
2. Install [Android Studio](https://developer.android.com/studio).
3. Di Android Studio buka **Settings → Plugins**, install plugin **Flutter**. Plugin Dart akan ikut diminta; setujui.
4. Buka **Settings → Languages & Frameworks → Android SDK**:
   - instal Android SDK Platform terbaru yang stabil;
   - instal Android SDK Build-Tools;
   - instal Android SDK Command-line Tools;
   - instal Android SDK Platform-Tools;
   - instal Android Emulator bila memakai emulator.
5. Download Flutter SDK stable dari [flutter.dev](https://docs.flutter.dev/get-started/install), ekstrak misalnya ke `C:\\src\\flutter`, lalu masukkan `C:\\src\\flutter\\bin` ke `PATH`.
6. Tutup dan buka terminal baru, kemudian jalankan:

```bash
flutter doctor
flutter doctor --android-licenses
```

Selesaikan semua lisensi Android sampai `flutter doctor` tidak menampilkan error yang menghalangi Android.

## Bootstrap project

```bash
git clone https://github.com/allifiz/webview-raka.git
cd webview-raka

# Membuat host Android sesuai versi Flutter lokal.
flutter create --platforms=android .
```

Setelah command tersebut, buka `android/app/src/main/AndroidManifest.xml` dan tambahkan tepat di bawah tag pembuka `<manifest ...>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Lalu instal dependency:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

> Host Android memang dibangkitkan pada setup pertama. Ini sengaja agar project tidak membawa Gradle/Android template usang dan selalu cocok dengan Flutter/Android Studio di mesin yang menjalankannya.

## Menjalankan aplikasi

Aplikasi harus menunjuk ke server Laravel yang bisa dijangkau device dan menggunakan HTTPS.

```bash
flutter run --dart-define=APP_URL=https://domain-staging-kamu.com/employee
```

Untuk device Android fisik:

1. Aktifkan **Developer options** dan **USB debugging**.
2. Hubungkan perangkat dengan kabel USB, lalu setujui RSA debugging.
3. Pastikan device terlihat melalui `flutter devices`.
4. Jalankan command di atas.

Untuk emulator, buat device melalui **Device Manager** di Android Studio lalu pilih device itu pada `flutter devices`.

## Penting untuk absensi

- Server Laravel produksi/staging harus **HTTPS**. Kamera dan GPS website lazim ditolak pada HTTP.
- Domain yang dipakai harus dapat diakses dari HP. `localhost` laptop bukan localhost HP.
- Web Laravel saat ini masih perlu punya logic `getUserMedia()` untuk capture foto; WebView hanya meneruskan izin Android saat website memintanya.
- Validasi IP Wi-Fi dan radius GPS tetap harus diputuskan Laravel. APK tidak boleh mem-bypass validasi backend.

## Build APK dan AAB

Untuk uji internal:

```bash
flutter build apk --debug --dart-define=APP_URL=https://domain-staging-kamu.com/employee
```

Untuk rilis Play Store, buat keystore terlebih dahulu:

```bash
keytool -genkey -v -keystore raka-upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias raka
```

Simpan keystore di lokasi aman **di luar repository**, buat `android/key.properties` mengikuti dokumentasi Flutter signing, lalu build:

```bash
flutter build appbundle --release --dart-define=APP_URL=https://domain-produksi-kamu.com/employee
```

Jangan commit `.jks`, password keystore, atau `android/key.properties`.

## Dokumen proyek

- [AGENTS.md](AGENTS.md) — konteks dan aturan untuk AI agent.
- [ARCHITECTURE.md](ARCHITECTURE.md) — batas tanggung jawab Flutter vs Laravel.
- [PROGRESS.md](PROGRESS.md) — kondisi kerja yang sudah terverifikasi.
- [TODO.md](TODO.md) — pekerjaan tersisa.
- [docs/UAT.md](docs/UAT.md) — skenario UAT positif, negatif, dan regresi.

## Validasi sebelum merge/rilis

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Lalu jalankan seluruh case di `docs/UAT.md` pada Android fisik dan URL staging.
