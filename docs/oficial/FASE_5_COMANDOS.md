# Fase 5 — Nginx con bind mount en `8080`

> Proyecto Final ISL135 · Grupo 7 · VM `Debian 13`
>
> Ejecuta los bloques en orden como `adminsys`, detente ante cualquier error y
> conserva las evidencias en `/proyecto/capturas/F05/`.

## Estado de esta guía

- [x] Punto de control 1: prevalidación de Docker, Git y puerto
- [x] Punto de control 2: sitio del Grupo 7 en `/proyecto/web`
- [x] Punto de control 3: ejecutar Nginx con bind mount
- [x] Punto de control 4: verificar HTML, HTTP, puerto, montaje y logs
- [x] Punto de control 5: evidencias, commit, push y snapshot `05-nginx`

## Evidencias previstas

| Archivo | Contenido |
|---|---|
| `F05_01_contenedor.png` | `docker ps`, puerto `8080` y política de reinicio |
| `F05_02_navegador.png` | Sitio del Grupo 7 en `http://localhost:8080` |
| `F05_03_logs_montaje.png` | Logs sin errores y bind mount `/proyecto/web` |
| `F05_04_snapshot.png` | Registro original del snapshot `05-nginx` |

## Punto de control 1 — Prevalidación

Confirma la VM y el usuario:

```bash
hostname
whoami
```

Resultado esperado:

```text
servidor-grupo7
adminsys
```

Confirma Docker y el estado de Git:

```bash
systemctl is-active docker
cd /proyecto
git status --short --branch
```

Resultados esperados: `active` y `## main...origin/main`, sin cambios.

Comprueba que el contenedor y el puerto estén libres:

```bash
docker ps -a --filter name=nginx-basico
sudo ss -ltnp | grep ':8080' || echo "Puerto 8080 libre"
```

El primer filtro solo debe mostrar encabezados. El segundo debe mostrar
`Puerto 8080 libre` o, si hay otro proceso, detenerse para investigarlo.

## Punto de control 2 — Crear el sitio

Crea `/proyecto/web/index.html` con contenido del Grupo 7:

```bash
cat > /proyecto/web/index.html <<'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Proyecto ISL135 · Grupo 7</title>
  <style>
    :root { --azul:#0b3d91; --claro:#f4f7fb; --texto:#1f2937; }
    * { box-sizing: border-box; }
    body { margin:0; font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
           color:var(--texto); background:var(--claro); line-height:1.6; }
    header { background:linear-gradient(135deg, #0b3d91, #1565c0); color:#fff;
             padding:3rem 1.5rem; text-align:center; }
    header h1 { margin:0 0 .5rem; font-size:2rem; }
    header p { margin:.25rem 0; opacity:.9; }
    main { max-width:900px; margin:2rem auto; padding:0 1.25rem; }
    .card { background:#fff; border-radius:12px; padding:1.5rem 1.75rem; margin-bottom:1.25rem;
            box-shadow:0 4px 14px rgba(15,23,42,.08); }
    h2 { color:var(--azul); margin-top:0; }
    code { background:#eef2ff; padding:.15rem .4rem; border-radius:4px; font-size:.95em; }
    footer { text-align:center; padding:1.5rem; color:#64748b; font-size:.9rem; }
    .badge { display:inline-block; background:#dcfce7; color:#166534; padding:.2rem .7rem;
             border-radius:999px; font-size:.85rem; font-weight:600; }
  </style>
</head>
<body>
  <header>
    <span class="badge">Servidor en línea</span>
    <h1>Proyecto Final ISL135</h1>
    <p>Servidor Linux automatizado con Docker</p>
    <p>Grupo 7 · Ciclo II–2026</p>
  </header>
  <main>
    <section class="card">
      <h2>¿Qué estás viendo?</h2>
      <p>Este sitio se sirve desde un contenedor Nginx dentro de una máquina virtual
         Debian 13. El contenido se monta desde <code>/proyecto/web</code> y se
         publica en el puerto <code>8080</code> del host.</p>
    </section>
    <section class="card">
      <h2>Servicios del proyecto</h2>
      <ul>
        <li><strong>8080:</strong> Nginx oficial con bind mount del sitio.</li>
        <li><strong>8081:</strong> imagen personalizada <code>servidor-grupo7</code>.</li>
        <li><strong>8082:</strong> Nginx en la red <code>red-proyecto</code>.</li>
        <li><strong>8083:</strong> Nginx con el volumen <code>volumen-web</code>.</li>
      </ul>
    </section>
    <section class="card">
      <h2>Automatización</h2>
      <p>El script <code>reporte_sistema.sh</code> se ejecuta cada 30 minutos mediante
         cron y registra el estado del servidor en
         <code>/var/log/proyecto/reporte_sistema.log</code>.</p>
    </section>
  </main>
  <footer>
    Universidad de El Salvador · Facultad Multidisciplinaria de Occidente<br>
    Introducción al Software Libre · 2026
  </footer>
</body>
</html>
EOF
```

Ajusta permisos y valida el contenido:

```bash
chmod 664 /proyecto/web/index.html
ls -l /proyecto/web/index.html
grep -F 'Grupo 7' /proyecto/web/index.html
```

El archivo debe pertenecer al grupo `web`, heredado mediante setgid, y contener
el texto `Grupo 7`. No uses `chmod 777`.

Crea el favicon y enlázalo para evitar un `404` de `favicon.ico` en los logs:

```bash
cat > /proyecto/web/favicon.svg <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <rect width="64" height="64" rx="12" fill="#0b3d91"/>
  <text x="32" y="44" text-anchor="middle" font-family="sans-serif"
        font-size="36" font-weight="700" fill="#ffffff">7</text>
</svg>
EOF
sed -i 's#</title>#</title>\n  <link rel="icon" type="image/svg+xml" href="/favicon.svg">#' /proyecto/web/index.html
chmod 664 /proyecto/web/favicon.svg
```

## Punto de control 3 — Ejecutar Nginx

```bash
docker run -d \
  --name nginx-basico \
  --restart unless-stopped \
  -p 8080:80 \
  -v /proyecto/web:/usr/share/nginx/html:ro \
  nginx:latest
```

La primera ejecución descargará `nginx:latest`. Debe imprimir un ID de
contenedor de 64 caracteres y no `port is already allocated`.

## Punto de control 4 — Verificar

```bash
docker ps --filter name=nginx-basico --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker port nginx-basico
docker inspect -f 'RestartPolicy={{.HostConfig.RestartPolicy.Name}}' nginx-basico
curl -I http://localhost:8080
curl -fsSI http://localhost:8080/favicon.svg
curl -fsS http://localhost:8080 | grep -F 'Grupo 7'
docker inspect -f '{{json .Mounts}}' nginx-basico
docker logs --tail 20 nginx-basico
```

Criterios:

- El contenedor se llama `nginx-basico` y está `Up`.
- El puerto interno `80/tcp` está publicado como `0.0.0.0:8080`.
- La política de reinicio es `RestartPolicy=unless-stopped`.
- `curl -I` devuelve `HTTP/1.1 200 OK`.
- El HTML contiene `Grupo 7`.
- El montaje muestra `Source=/proyecto/web`,
  `Destination=/usr/share/nginx/html` y `RW=false`.
- Los logs no contienen `emerg`, `error` ni `crit`.

Desde el host, abre `http://localhost:8080`. Debe mostrarse el sitio del Grupo 7
con la etiqueta «Servidor en línea».

## Punto de control 5 — Evidencias y cierre

Guarda en `/proyecto/capturas/F05/`:

1. `F05_01_contenedor.png`: `docker ps`, `docker port` y política de reinicio.
2. `F05_02_navegador.png`: `http://localhost:8080` en el navegador del host.
3. `F05_03_logs_montaje.png`: `curl -I`, montaje y logs sin errores.
4. `F05_04_snapshot.png`: snapshot `05-nginx` creado y verificado.

Después:

```bash
cd /proyecto
git add web/index.html web/favicon.svg capturas/F05
git diff --cached --stat
git commit -m "Fase 5: Nginx con bind mount en 8080"
git push
git status --short --branch
```

El estado final debe ser `## main...origin/main` sin cambios.

Snapshot desde el host:

```bash
VBoxManage snapshot "Debian 13" take "05-nginx"
VBoxManage snapshot "Debian 13" list
```

> **Nota de recuperación del Grupo 7:** VirtualBox perdió posteriormente el
> registro de `01-fase1`, `02-fase2` y del primer `05-nginx`. El 30/10/2026 se
> creó el punto consolidado `05-nginx-recuperado`
> (`1260d56c-1a07-4357-aa4f-b052d35953bc`) como respaldo previo a la Fase 6.
> No es necesario recrear los snapshots históricos exactos.

## Solución de problemas

| Síntoma | Causa probable | Comprobación |
|---|---|---|
| `403 Forbidden` | `index.html` ausente o sin lectura | `ls -l /proyecto/web` |
| `404 Not Found` | Mount en ruta incorrecta | `docker inspect -f '{{json .Mounts}}' nginx-basico` |
| `port is already allocated` | Proceso usando `8080` | `sudo ss -ltnp \| grep ':8080'` |
| Contenedor reinicia | Imagen o montaje inválido | `docker logs nginx-basico` |
| Falla solo desde el host | Reenvío NAT `8080` ausente | Revisar VirtualBox; probar `curl` dentro de la VM |
