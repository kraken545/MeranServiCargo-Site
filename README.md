# MeranServiCargo-Site

> Sitio web estático de presentación para Meran Servi Cargo — one-page en un solo `index.html`, 4 idiomas (ES/EN/PAP/NL), sin build y sin dependencias.

## Quick start

Nada que instalar — abre `index.html` directo en el navegador:

```bash
open index.html
```

Con Docker (nginx, sitio local con bind mount — los cambios se ven con refresh):

```bash
docker compose up -d   # http://localhost:8080
```

## Estructura

```text
.
├── index.html          # sitio completo: HTML + CSS + JS + i18n, en un archivo
├── img/                # fotos y logos reales del negocio, optimizados
│   └── favicon.png
├── fonts/              # Inter (woff2 variable) servido local — sin CDNs
├── _headers            # cabeceras HTTP (cache, seguridad) para Cloudflare
├── robots.txt
├── sitemap.xml
├── 404.html
├── docker-compose.yml  # sitio local (nginx:alpine, puerto 8080)
└── .dockerignore
```

## Idiomas

El sitio se traduce con el mismo motor que la app original del repo `MeranServiCargo`: atributos `data-i18n` + un objeto `translations` con 4 diccionarios completos.

| Código | Idioma | Notas |
| --- | --- | --- |
| `es` | Español | Predeterminado |
| `en` | English | |
| `pap` | Papiamentu | |
| `nl` | Nederlands | |

El idioma elegido se guarda en `localStorage` (`meran_lang`). Sin JS, el HTML ya viene en español.

## Deploy

GitHub → Cloudflare Worker. Sin build: los assets se suben tal cual.

Todo en un comando (commit + push + redeploy):

```bash
./deploy.sh
```

La primera vez abre el navegador para iniciar sesión en Cloudflare (`wrangler login`). Alternativa con token de API:

```bash
export CLOUDFLARE_API_TOKEN=xxxxx
export CLOUDFLARE_ACCOUNT_ID=xxxxx
./deploy.sh
```

Configuración en `wrangler.toml` (worker `meranservicargo`, assets en `./`, 404 propio). Desplegado en: `https://meranservicargo.dejesuse545.workers.dev/`

## Personalización

| Qué | Dónde |
| --- | --- |
| Textos de cada idioma | objeto `translations` en `index.html` |
| Número WhatsApp | constante `WA_NUMBER` (JS, inicio del `<script>`) |
| Teléfono / direcciones / Facebook | secciones Contacto, Sedes y footer |
| Colores (navy/rojo) | variables `--navy`, `--red`, … en `:root` |
| Google Maps embebido (Curaçao) | iframe en la sección Sedes |

## Cómo funciona

1. El HTML se sirve 100% estático: CSS y JS van inline en `index.html`.
2. Al cargar, `applyLang()` aplica el idioma guardado a cada `[data-i18n]` y a los placeholders `[data-i18n-ph]`.
3. Los enlaces `.wa-link` (header, hero, tarjetas, flotante, footer) se generan por idioma: `https://wa.me/59996592918?text=…` con el mensaje prefijado traducido.
4. El formulario de contacto no tiene backend: al enviar abre WhatsApp con el mensaje pre-llenado.
5. El selector de idioma vive en el header (escritorio) y en el footer; en móvil también dentro del menú hamburguesa.

## Limits

- Sitio **estático de presentación**: no hay backend, login ni panel.
- El formulario deriva a WhatsApp; no envía correo.
- Teléfonos, direcciones, redes y enlaces están hardcodeados en `index.html` — edítalos ahí si cambian.
- No se inventa contenido: tarifas, tiempos y testimonios se añaden solo cuando el negocio los confirme.
