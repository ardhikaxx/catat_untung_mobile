# Kebijakan Keamanan (Security Policy)

Keamanan dan privasi data pengguna adalah prioritas utama kami dalam pengembangan aplikasi **Catat Untung**.

---

## 🛡️ Jaminan Privasi 100% Offline

Aplikasi **Catat Untung** dibangun dengan arsitektur *Zero-Cloud*:
- Tidak ada data transaksi, omzet, modal, atau kontak yang dikirimkan ke server eksternal mana pun.
- Seluruh penyimpanan data menggunakan SQLite lokal di dalam direktori internal yang terisolasi (*sandbox*) sistem operasi Android/iOS.
- Tidak terdapat tracker analitik pihak ketiga atau iklan yang melacak aktivitas pengguna.

---

## 📋 Versi yang Didukung

| Versi | Didukung |
| :--- | :--- |
| 1.0.x | :white_check_mark: |

---

## 🚨 Melaporkan Kerentanan (Reporting a Vulnerability)

**Harap tidak melaporkan potensi kerentanan keamanan melalui GitHub Issues publik.**

Jika Anda menemukan celah keamanan atau bug yang berpotensi mengekspos data lokal perangkat, harap laporkan secara privat kepada pengembang:

```
Pengembang: Yanuar Ardhika Rahmadhani Ubaidillah
GitHub: @ardhikaxx
```

Kami akan meninjau laporan Anda dalam waktu **48 jam** dan memberikan tindak lanjut perbaikan sesegera mungkin.

---

## 🔒 Praktik Keamanan Terbaik untuk Pengguna

1. **Cadangkan Data Secara Rutin**: Gunakan fitur *Pengaturan > Backup & Pemulihan* untuk menyimpan berkas cadangan JSON ke Google Drive pribadi atau media eksternal aman Anda.
2. **Kunci Layar Perangkat**: Selalu pasang kunci layar (PIN/Fingerprint) pada smartphone Anda untuk mencegah pihak yang tidak berwenang melihat rekap keuangan toko Anda.
3. **Unduh dari Sumber Resmi**: Pastikan selalu mengunduh file APK rilis resmi dari repository ini.
