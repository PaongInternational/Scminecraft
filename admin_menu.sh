#!/bin/bash
# admin_menu.sh - Menu interaktif untuk kontrol server dan optimasi

# Pastikan skrip optimasi memiliki izin eksekusi
chmod +x opt_high.sh opt_medium.sh opt_low.sh 04_stop_all.sh 03_start_services.sh

# Fungsi untuk melakukan RESTART AMAN (stop total lalu start total)
restart_project() {
    echo -e "\n----------------------------------------"
    echo "  Melakukan Restart Proyek AMAN..."
    echo "----------------------------------------"
    # 1. Hentikan semua layanan
    bash 04_stop_all.sh
    sleep 2
    
    # 2. Mulai kembali semua layanan
    echo "  Memulai ulang layanan..."
    tmux new-session -d -s admin_menu "bash admin_menu.sh" # Mulai ulang sesi admin_menu agar pengguna kembali ke sini
    
    # Panggil 03_start_services.sh (yang akan memanggil TMUX attach di akhir)
    # Kita tidak bisa memanggilnya langsung di sini karena kita berada di sesi TMUX
    # Sebagai gantinya, kita akan keluar dari sesi TMUX ini dan meminta pengguna menjalankannya secara manual
    # Karena persyaratan meminta *otomatis* attach, kita harus menggunakan trik TMUX.
    
    # Alternatif: Panggil langsung 03_start_services.sh di background dan detach
    /bin/bash 03_start_services.sh 2>&1 > /dev/null &
    
    echo -e "\n  Layanan BDS/Ngrok sedang dimulai ulang..."
    echo "  Anda akan secara otomatis dialihkan ke menu dalam beberapa detik."
    sleep 3
    tmux kill-session -t admin_menu 2>/dev/null # Bunuh sesi lama ini

    exit 0 # Keluar dari skrip
}

# Fungsi untuk menampilkan menu
show_menu() {
    clear
    echo "========================================"
    echo "  XipserCloud BDS - ADMIN CONSOLE"
    echo "  Saat ini di sesi TMUX: admin_menu"
    echo "========================================"
    echo "[1] Optimasi Jarak Render: TINGGI (16/8)"
    echo "[2] Optimasi Jarak Render: STANDAR (10/6) (Default)"
    echo "[3] Optimasi Jarak Render: RENDAH (6/4) (Anti-Lag)"
    echo "----------------------------------------"
    echo "[4] Attach ke Console Server (mc_server)"
    echo "[5] Lihat Monitor Ngrok (IP/Port Publik)"
    echo "[9] SHUTDOWN SEMUA LAYANAN (Aman)"
    echo "----------------------------------------"
    read -p "Masukkan pilihan (1-5, 9): " choice
}

while true; do
    show_menu
    
    case $choice in
        1)
            echo "Mengatur Optimasi Tinggi..."
            bash opt_high.sh
            restart_project
            ;;
        2)
            echo "Mengatur Optimasi Standar..."
            bash opt_medium.sh
            restart_project
            ;;
        3)
            echo "Mengatur Optimasi Rendah/Anti-Lag..."
            bash opt_low.sh
            restart_project
            ;;
        4)
            echo "Melepaskan dari Admin Console dan Attach ke mc_server..."
            # Detach dari sesi admin_menu, lalu attach ke mc_server
            tmux detach -s admin_menu
            tmux attach -t mc_server
            # Skrip ini akan terus berjalan di background sesi admin_menu sampai dibunuh.
            # Kita perlu memastikan loop ini dihentikan setelah attach.
            break
            ;;
        5)
            echo "Melepaskan dari Admin Console dan Attach ke monitor_info..."
            tmux detach -s admin_menu
            tmux attach -t monitor_info
            break
            ;;
        9)
            echo "Melakukan SHUTDOWN AMAN..."
            bash 04_stop_all.sh
            echo "Semua layanan telah dihentikan. Keluar dari Termux jika sudah selesai."
            break
            ;;
        *)
            echo "Pilihan tidak valid. Tekan ENTER untuk melanjutkan..."
            read
            ;;
    esac
done
