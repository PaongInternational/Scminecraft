Panduan Server Minecraft Bedrock Edition (BDS) di Termux
Ini adalah proyek BDS (Bedrock Dedicated Server) yang dirancang untuk berjalan di lingkungan Termux menggunakan sesi TMUX untuk layanan latar belakang (Server, Ngrok, Monitor).
Detail Utama Server
| Parameter | Nilai |
|---|---|
| Nama Server Default | XipserCloud |
| Versi BDS | 1.21.3.03 |
| Maksimal Pemain | 15 |
| Ngrok Token | Termasuk dalam skrip setup |
1. Instalasi (Pilih Salah Satu Metode)
Pilih salah satu dari dua skrip setup di bawah. Skrip ini akan menginstal paket dasar (tmux, wget, unzip, curl, nano, jq) dan menyiapkan Ngrok.
Metode Normal (Direkomendasikan)
Gunakan metode ini jika pkg install berfungsi dengan baik.
bash 01_setup_all.sh

Metode Cadangan (Alternatif)
Gunakan metode ini jika pkg install mengalami masalah, karena ini menggunakan apt install.
bash 01b_setup_alt.sh

2. Urutan Eksekusi
Setelah menjalankan salah satu skrip setup di atas, ikuti langkah-langkah berikut:
 * Konfigurasi Server: Sesuaikan file server.properties dengan pengaturan awal.
   bash 02_config_server.sh

 * Mulai Layanan (Wajib): Ini akan memulai server BDS, Ngrok tunnel, dan layanan monitor secara serentak di sesi TMUX terpisah, lalu melampirkan Anda ke Admin Console.
   bash 03_start_services.sh

3. Panduan Admin Console
Setelah menjalankan 03_start_services.sh, Anda akan berada di menu interaktif (admin_menu.sh).
| Opsi | Fungsi |
|---|---|
| [1] Optimasi Tinggi (16/8) | Mengatur view-distance=16 dan simulation-distance=8. Server akan RESTART AMAN. |
| [2] Optimasi Standar (10/6) | Mengatur view-distance=10 dan simulation-distance=6. Server akan RESTART AMAN. |
| [3] Optimasi Rendah (6/4) | Mengatur view-distance=6 dan simulation-distance=4 (Anti-Lag). Server akan RESTART AMAN. |
| [4] Attach ke Console Server | Keluar dari menu admin dan masuk ke konsol BDS utama (untuk perintah op, say, dll.). |
| [5] Lihat Monitor Ngrok | Melihat alamat IP dan Port publik Ngrok secara real-time. |
| [9] Shutdown Aman | Menghentikan server BDS (menyimpan dunia) dan mematikan semua sesi TMUX. |
Untuk Keluar dari TMUX (Detach): Tekan Ctrl + b diikuti oleh d.
