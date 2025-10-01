#!/bin/bash
# 02_config_server.sh - Mengatur konfigurasi awal server.properties

SERVER_PROPERTIES="./server/server.properties"
SERVER_NAME="XipserCloud"
MAX_PLAYERS="15"
PLAYER_LANGUAGE="id_ID"
VIEW_DISTANCE="10"
SIMULATION_DISTANCE="6"

echo "--- Konfigurasi Server.properties Awal ---"

if [ ! -f "$SERVER_PROPERTIES" ]; then
    echo "ERROR: File $SERVER_PROPERTIES tidak ditemukan. Pastikan BDS sudah diunduh dan di-unzip di folder './server'."
    exit 1
fi

# Fungsi untuk mengganti nilai dalam server.properties
function set_property {
    local key=$1
    local value=$2
    # Menggunakan sed untuk mencari dan mengganti baris
    if grep -q "^${key}=" "$SERVER_PROPERTIES"; then
        # Mengganti baris yang sudah ada
        sed -i "s/^${key}=.*/${key}=${value}/" "$SERVER_PROPERTIES"
        echo "Diatur: ${key}=${value}"
    else
        # Menambahkan baris jika belum ada (meskipun biasanya file default BDS lengkap)
        echo "${key}=${value}" >> "$SERVER_PROPERTIES"
        echo "Ditambahkan: ${key}=${value}"
    fi
}

# --- Konfigurasi Wajib ---
set_property "server-name" "$SERVER_NAME"
set_property "max-players" "$MAX_PLAYERS"
set_property "default-player-language" "$PLAYER_LANGUAGE"

# --- Optimasi Standar Awal ---
echo -e "\n--- Mengatur Optimasi Awal (STANDAR) ---"
set_property "view-distance" "$VIEW_DISTANCE"
set_property "simulation-distance" "$SIMULATION_DISTANCE"

echo -e "\n[SELESAI] Konfigurasi server.properties selesai."
echo "Lanjutkan dengan 'bash 03_start_services.sh' untuk memulai layanan."
