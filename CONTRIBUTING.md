# Contributing to Catat Untung

Terima kasih atas minat Anda untuk berkontribusi pada pengembangan aplikasi **Catat Untung**! Proyek ini bertujuan memberdayakan jutaan pemilik warung dan UMKM di Indonesia melalui perangkat lunak gratis, cepat, dan 100% offline.

Panduan berikut dirancang untuk menjaga kualitas basis kode tetap konsisten, bersih, dan mudah dipelihara.

---

## 🚀 Alur Kontribusi (Getting Started)

1. **Fork Repository** ke akun GitHub Anda.
2. **Clone** hasil fork ke komputer lokal:
   ```bash
   git clone https://github.com/<username-anda>/catat_untung_mobile.git
   cd catat_untung_mobile
   ```
3. **Buat Branch Fitur Baru** dari branch `main`:
   ```bash
   git checkout -b feature/nama-fitur-anda
   # atau untuk perbaikan bug:
   git checkout -b fix/nama-bug-anda
   ```
4. Pasang dependensi dan pastikan project berjalan:
   ```bash
   flutter pub get
   dart run build_runner build
   ```
5. Buat perubahan kode Anda dan lakukan commit dengan pesan yang jelas dan terstruktur.
6. Push perubahan ke fork Anda dan buka **Pull Request (PR)** ke branch `main`.

---

## 📐 Standar Penulisan Kode (Code Style)

- **Pedoman Gaya Kode**: Ikuti panduan resmi [Effective Dart](https://dart.dev/effective-dart) dan aturan linter yang ada di `analysis_options.yaml`.
- **Ikonografi**: Selalu gunakan icon dari package `lucide_icons` (`LucideIcons.<namaIcon>`).
- **Pembersihan Linting**: Sebelum melakukan commit, pastikan perintah analisis kode bersih tanpa warning:
   ```bash
   flutter analyze
   ```
- **Format Otomatis**: Gunakan formatter resmi Dart:
   ```bash
   dart format .
   ```

---

## 🧪 Pengujian (Testing)

Sebelum mengajukan Pull Request, pastikan seluruh rangkaian unit test dan widget test lulus 100%:

```bash
flutter test
```

Jika Anda menambahkan fitur atau modul baru, sertakan pengujian (*test cases*) terkait di dalam folder `test/`.

---

## 📝 Konvensi Pesan Commit

Gunakan standar [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Penambahan fitur atau modul baru.
- `fix:` Perbaikan bug atau error.
- `refactor:` Perubahan struktur kode tanpa mengubah fungsi aplikasi.
- `perf:` Peningkatan performa komputasi atau memori.
- `style:` Perubahan tampilan, estetika UI, margin, atau padding.
- `docs:` Pembaruan atau penambahan dokumentasi (.md).
- `test:` Penambahan atau perbaikan pengujian otomatis.

**Contoh:**
```bash
git commit -m "feat: add customer contact field in daily recap"
```

---

## 🤝 Kode Etik (Code of Conduct)

Jaga interaksi yang ramah, santun, dan saling menghargai antarkontributor. Diskriminasi atau perilaku yang tidak pantas tidak akan ditoleransi di proyek ini.
