#!/bin/bash
# 01_setup_all.sh - Skrip Setup Normal (Menggunakan pkg)

# --- Variabel Konfigurasi ---
BDS_VERSION="1.21.3.03"
BDS_URL="https://download.minecraft.net/bin/mobile/bedrock-server-${BDS_VERSION}.zip"
NGROK_AUTHTOKEN="33RKXoLi8mLMccvpJbo1LoN3fCg_4AEGykdpBZeXx2TFHaCQj"
NGROK_ZIP="ngrok-stable-linux-arm64.zip"

echo "--- 1. Instalasi Paket Dasar (pkg) ---"
pkg update -y
pkg upgrade -y
pkg install -y tmux wget unzip curl nano jq

# --- 2. Setup Folder Server BDS ---
echo -e "\n--- 2. Mengunduh dan Menyiapkan Server BDS ${BDS_VERSION} ---"
if [ -d "./server" ]; then
    echo "Folder 'server' sudah ada. Melewati pengunduhan BDS."
else
    mkdir -p server
    cd server
    wget -O bds.zip "$BDS_URL"
    unzip bds.zip
    rm bds.zip
    chmod +x bedrock_server
    cd ..
    echo "Server BDS siap di folder './server'."
fi

# --- 3. Setup Ngrok ---
echo -e "\n--- 3. Mengunduh dan Mengkonfigurasi Ngrok ---"
if ! command -v ngrok &> /dev/null; then
    # Mengunduh Ngrok (Termux biasanya menggunakan ARM64)
    wget -O ngrok.zip "https://bin.equinox.io/c/4VmDzA7iaHb/${NGROK_ZIP}"
    unzip ngrok.zip
    chmod +x ngrok
    mv ngrok $PREFIX/bin/
    rm ngrok.zip
    echo "Ngrok diinstal ke $PREFIX/bin/."
else
    echo "Ngrok sudah terinstal."
fi

# Mengkonfigurasi Ngrok dengan Auth Token
ngrok authtoken $NGROK_AUTHTOKEN
echo "Ngrok Auth Token telah diatur."

echo -e "\n[SELESAI] Setup selesai. Lanjutkan dengan 'bash 02_config_server.sh'."

# Memberikan izin eksekusi untuk semua skrip
chmod +x 01_setup_all.sh 01b_setup_alt.sh 02_config_server.sh 03_start_services.sh 04_stop_all.sh admin_menu.sh opt_high.sh opt_medium.sh opt_low.sh
