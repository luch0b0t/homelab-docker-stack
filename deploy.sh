#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "==== Pulling changes from GitHub ===="
git pull origin main

# Detecta carpetas modificadas
changed_dirs=$(git diff --name-only HEAD@{1} HEAD | cut -d/ -f1 | sort -u)

for dir in $changed_dirs; do
  if [ -f "$dir/docker-compose.yml" ]; then
    echo "==> Rebuild and redeploy $dir"
    docker compose -f "$dir/docker-compose.yml" up -d --build
  fi
done