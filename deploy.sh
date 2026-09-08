#!/usr/bin/env bash
# Despliegue automático: GitHub + Cloudflare Worker en un solo comando.
# Uso:  ./deploy.sh        (o:  bash deploy.sh)
set -euo pipefail
cd "$(dirname "$0")"

echo "== 1/3 Sincronizando con GitHub =="
git add -A
if git diff --cached --quiet; then
  echo "   sin cambios; nada que subir"
else
  git commit -m "deploy $(date '+%Y-%m-%d %H:%M')"
  git push
  echo "   push OK"
fi

echo "== 2/3 Autenticando Wrangler (solo la primera vez) =="
if ! npx --yes wrangler whoami >/dev/null 2>&1; then
  echo "   abriendo navegador para iniciar sesion en Cloudflare..."
  npx --yes wrangler login
fi

echo "== 3/3 Desplegando a Cloudflare Worker =="
npx --yes wrangler deploy
echo "> Listo: https://meranservicargo.dejesuse545.workers.dev/"
