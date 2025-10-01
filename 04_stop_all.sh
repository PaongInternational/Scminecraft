#!/bin/bash
# 04_stop_all.sh - Skrip untuk menghentikan semua layanan TMUX dengan aman

echo "--- Melakukan Shutdown Aman ---"

# 1. Hentikan Server Minecraft (mc_server) dengan perintah 'stop'
if tmux has-session -t mc_server 2>/dev/null; then
    echo "Mengirim perintah 'stop' ke mc_server untuk menyimpan dunia..."
    # Kirim perintah 'stop' diikuti oleh ENTER
    tmux send-keys -t mc_server "stop" C-m
    
    # Tunggu 7 detik untuk proses penyimpanan dunia
    echo "Menunggu 7 detik hingga dunia tersimpan..."
    sleep 7
    
    # Bunuh sesi mc_server
    tmux kill-session -t mc_server
    echo "Sesi mc_server dihentikan."
else
    echo "Sesi mc_server tidak aktif."
fi

# 2. Bunuh sesi TMUX lainnya
# Catatan: Kita bunuh secara paksa karena ngrok_tunnel dan monitor_info tidak perlu shutdown 'aman'.

SESSIONS="ngrok_tunnel monitor_info admin_menu"

for session in $SESSIONS; do
    if tmux has-session -t $session 2>/dev/null; then
        tmux kill-session -t $session
        echo "Sesi $session dihentikan."
    else
        echo "Sesi $session tidak aktif."
    fi
done

echo -e "\n[SELESAI] Semua layanan TMUX telah dimatikan dengan aman."
