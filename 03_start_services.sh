#!/bin/bash
# 03_start_services.sh - Memulai server, Ngrok, dan monitor di TMUX

# Cek apakah sesi TMUX sudah berjalan. Jika ya, matikan dengan aman.
if tmux has-session -t mc_server 2>/dev/null || tmux has-session -t ngrok_tunnel 2>/dev/null; then
    echo "Layanan sudah berjalan. Melakukan SHUTDOWN AMAN terlebih dahulu..."
    bash 04_stop_all.sh
    sleep 3
fi

echo "--- Memulai Layanan Latar Belakang di TMUX ---"

# 1. Sesi TMUX: mc_server (Menjalankan BDS)
echo "1. Memulai Server Minecraft (mc_server)..."
tmux new-session -d -s mc_server "cd server && LD_LIBRARY_PATH=./ ./bedrock_server"

# 2. Sesi TMUX: ngrok_tunnel (Menjalankan Ngrok)
echo "2. Memulai Ngrok Tunnel (ngrok_tunnel)..."
# Ngrok tunneling ke port default BDS (19132)
tmux new-session -d -s ngrok_tunnel 'ngrok tcp 19132 --log=stdout > /dev/null'
sleep 5 # Beri waktu Ngrok untuk inisialisasi

# 3. Sesi TMUX: monitor_info (Monitor IP Publik Ngrok)
echo "3. Memulai Monitor Ngrok (monitor_info)..."
# Loop yang memanggil Ngrok API (127.0.0.1:4040) untuk mendapatkan IP/Port publik
MONITOR_SCRIPT="
while true; do
    clear
    echo '========================================='
    echo '        MONITOR ALAMAT SERVER            '
    echo '========================================='
    echo ''
    
    # Ambil data dari Ngrok API dan format menggunakan jq
    STATUS_CHECK=\$(curl -s http://127.0.0.1:4040/api/tunnels)
    
    if echo \"\$STATUS_CHECK\" | jq -e '.tunnels | length > 0' &> /dev/null; then
        TUNNEL_INFO=\$(echo \"\$STATUS_CHECK\" | jq -r '.tunnels[0].public_url')
        
        # Ekstraksi IP dan Port
        IP_ADDRESS=\$(echo \"\$TUNNEL_INFO\" | sed -e 's/tcp:\/\///g' | cut -d: -f1)
        PORT_NUMBER=\$(echo \"\$TUNNEL_INFO\" | sed -e 's/tcp:\/\///g' | cut -d: -f2)

        echo \"Server IP: \${IP_ADDRESS}\"
        echo \"Server Port: \${PORT_NUMBER}\"
        echo \"\"
        echo \"Alamat Penuh (Salin & Tempel): \${TUNNEL_INFO}\"
    else
        echo 'NGROK BELUM TERHUBUNG atau API OFFLINE...'
    fi
    
    echo ''
    echo 'UPDATE SETIAP 5 DETIK. Tekan Ctrl+b d untuk detach.'
    sleep 5
done
"
tmux new-session -d -s monitor_info "$MONITOR_SCRIPT"

# 4. Sesi TMUX: admin_menu (Admin Console)
echo "4. Memulai Admin Console (admin_menu)..."
tmux new-session -d -s admin_menu "bash admin_menu.sh"

echo -e "\n[SELESAI] Semua layanan dimulai. Melampirkan ke Admin Console..."
tmux attach -t admin_menu
