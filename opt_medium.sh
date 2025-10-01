#!/bin/bash
# opt_medium.sh - Mengatur BDS ke optimasi standar (Keseimbangan)

SERVER_PROPERTIES="./server/server.properties"
VIEW_DISTANCE="10"
SIMULATION_DISTANCE="6"

echo "Mengubah konfigurasi ke OPTIMASI STANDAR (Render: $VIEW_DISTANCE, Simulasi: $SIMULATION_DISTANCE)..."

if [ ! -f "$SERVER_PROPERTIES" ]; then
    echo "ERROR: File $SERVER_PROPERTIES tidak ditemukan."
    exit 1
fi

# Menggunakan sed untuk mengganti nilai
sed -i "s/^view-distance=.*/view-distance=${VIEW_DISTANCE}/" "$SERVER_PROPERTIES"
sed -i "s/^simulation-distance=.*/simulation-distance=${SIMULATION_DISTANCE}/" "$SERVER_PROPERTIES"

echo "Konfigurasi disimpan. Server perlu di-restart agar perubahan diterapkan."
