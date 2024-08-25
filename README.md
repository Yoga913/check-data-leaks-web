# check-data-leaks-web

Ini adalah skrip bash sederhana untuk memeriksa potensi kebocoran data pada domain dengan memeriksa status HTTP dari jalur tertentu. Skrip ini mencoba kedua protokol (HTTP dan HTTPS) untuk setiap jalur yang ditentukan.

<img src="https://github.com/Yoga913/check-data-leaks-web/blob/main/1.png">

## Persyaratan

Pastikan Anda memiliki `curl` terinstal pada sistem Anda. Skrip ini menggunakan `curl` untuk memeriksa status HTTP dari URL.

## Penggunaan

1. Simpan skrip bash dalam sebuah file, misalnya `checkleaks.sh`.
2. Berikan izin eksekusi pada file tersebut:
```bash
   chmod +x checkleaks.sh
```
3. Jalankan skrip dengan menyertakan domain sebagai argumen:
```bash
   ./checkleaks.sh <domain>
```

## Contoh

Misalnya Anda ingin memeriksa jalur `/sensitive-data` pada domain `example.com`, Anda dapat menambahkan `/sensitive-data` ke dalam array `data_leakage_paths` dan menjalankan skrip sebagai berikut:

```bash
./checkleaks.sh example.com
```

## Catatan

- Pastikan jalur yang ingin Anda periksa ditambahkan ke dalam array `data_leakage_paths`.
- Skrip ini hanya memberikan indikasi awal tentang kemungkinan kebocoran data dan tidak menggantikan pemantauan keamanan yang lebih komprehensif.

## Lisensi

Skrip ini dirilis di bawah [Lisensi MIT](LICENSE).
