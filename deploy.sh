#!/bin/bash
set -euo pipefail

# === Настройки ===
PROJECT_DIR=""
LOG_FILE="$PROJECT_DIR/deploy.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

cd "$PROJECT_DIR"

echo "[$DATE] 🚀 Starting deployment..." | tee -a "$LOG_FILE"

# === Обновление кода ===
echo "[$DATE] 🔄 Pulling latest changes..." | tee -a "$LOG_FILE"
git pull --recurse-submodules
git submodule update --remote --recursive

# === Проверка статуса сабмодулей ===
echo "[$DATE] 📦 Submodules status:" | tee -a "$LOG_FILE"
git submodule status | tee -a "$LOG_FILE"

# === Пересборка и перезапуск Docker ===
echo "[$DATE] 🐳 Rebuilding containers..." | tee -a "$LOG_FILE"
docker compose build --pull

echo "[$DATE] 🔁 Restarting services..." | tee -a "$LOG_FILE"
docker compose up -d

# === Очистка старых неиспользуемых образов ===
echo "[$DATE] 🧹 Cleaning up old images..." | tee -a "$LOG_FILE"
docker image prune -f

echo "[$DATE] ✅ Deployment completed successfully!" | tee -a "$LOG_FILE"
