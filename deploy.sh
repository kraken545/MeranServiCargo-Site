#!/usr/bin/env bash
# Sincroniza con GitHub → Cloudflare Pages despliega automáticamente.
# Requisito: proyecto Pages conectado al repo (Workers & Pages → Connect to Git).
set -euo pipefail
cd "$(dirname "$0")"

echo "== Sincronizando con GitHub =="
git add -A
if git diff --cached --quiet; then
  echo "   sin cambios; nada que subir"
else
  git commit -m "deploy $(date '+%Y-%m-%d %H:%M')"
  echo "   commit OK"
fi
git push
echo "✔ push enviado. Cloudflare Pages despliega automáticamente."
