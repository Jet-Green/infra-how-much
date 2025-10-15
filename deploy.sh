#!/bin/bash
set -e

# Обновляем сабмодули на нужную ветку
git submodule update --init --remote

# Пересобираем и запускаем всё
docker compose up -d --build
