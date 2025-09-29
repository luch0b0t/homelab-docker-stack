#!/bin/bash
set -e
cd "$(dirname "$0")"

# 1) Cargar .env de la raíz
if [[ -f .env ]]; then
  set -o allexport; source .env; set +o allexport
  echo "exported .env"
fi

# 2) Cargar secretos privados (si existen)
if [[ -f ~/.ghcr_env ]]; then
  source ~/.ghcr_env
  docker login ghcr.io -u "${GHCR_USER}" -p "${GHCR_PAT}" || true
  echo "sourcing private secrets"
fi

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
