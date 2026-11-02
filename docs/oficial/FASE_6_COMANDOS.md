# Fase 6 — Imagen personalizada `servidor-grupo7` en `8081`

> Proyecto Final ISL135 · Grupo 7 · VM `Debian 13`
>
> Esta fase comienza después de verificar las fases 1 a 5. Ejecuta los bloques
> en orden como `adminsys`, detente ante cualquier salida inesperada y guarda
> las evidencias en `/proyecto/capturas/F06/`.

## Estado de esta guía

- [x] Punto de control 1: prevalidar fase 5, Git y puerto `8081`
- [x] Punto de control 2: crear `Dockerfile` y `.dockerignore`
- [x] Punto de control 3: construir la imagen `servidor-grupo7`
- [x] Punto de control 4: ejecutar y verificar `nginx-personalizado`
- [x] Punto de control 5: comparar `8080` y `8081`
- [x] Punto de control 6: evidencias, commit, push y snapshot `06-imagen`

> **Fase 6 completada el 30/10/2026.** Commits `c5f1848` y `c6fdbea`;
> snapshot `06-imagen` con UUID
> `c2532f24-b760-4e38-922d-1c8e71b21fbf`.

## Evidencias previstas

| Archivo | Contenido |
|---|---|
| `F06_01_dockerfile.png` | `Dockerfile`, `.dockerignore` y contenido del sitio |
| `F06_02_build_imagen.png` | `docker build` e imagen `servidor-grupo7` |
| `F06_03_navegador_8081.png` | Sitio del Grupo 7 en `http://localhost:8081` |
| `F06_04_comparacion.png` | `8080` y `8081` con HTTP `200` y diferencia del montaje |
| `F06_05_snapshot.png` | Snapshot `06-imagen` creado y listado |

## Punto de control 1 — Prevalidación

Confirma la VM y el usuario:

```bash
hostname
whoami
id -nG
```

Resultados esperados:

```text
servidor-grupo7
adminsys
```

La lista de grupos debe incluir `docker`.

Confirma Docker y Git:

```bash
systemctl is-active docker
cd /proyecto
git status --short --branch
```

Resultados esperados: `active` y `## main...origin/main`, sin cambios.

Comprueba que la fase 5 siga disponible:

```bash
docker ps --filter name=nginx-basico --format '{{.Names}} | {{.Status}} | {{.Ports}}'
curl -sS -o /dev/null -w '8080 HTTP %{http_code}\n' http://localhost:8080
```

`nginx-basico` debe estar `Up`, con `0.0.0.0:8080->80/tcp`, y responder
`8080 HTTP 200`.

Comprueba que el contenedor y el puerto de la fase 6 estén libres:

```bash
docker ps -a --filter name=nginx-personalizado
sudo ss -ltnp | grep ':8081' || echo "Puerto 8081 libre"
```

No debe existir `nginx-personalizado` y debe aparecer `Puerto 8081 libre`.

Comprueba los archivos base:

```bash
test -f /proyecto/web/index.html && echo "index.html listo"
test -f /proyecto/web/favicon.svg && echo "favicon.svg listo"
grep -F 'Grupo 7' /proyecto/web/index.html
```

## Punto de control 2 — Crear Dockerfile y .dockerignore

Crea `/proyecto/Dockerfile`:

```bash
cat > /proyecto/Dockerfile <<'EOF'
FROM nginx:latest

LABEL maintainer="Grupo 7 - ISL135"
LABEL description="Servidor web personalizado del proyecto final"

# Copia el sitio dentro de la imagen
COPY web/ /usr/share/nginx/html/

# Documenta el puerto que expone Nginx
EXPOSE 80

# Mantiene Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
EOF
```

Crea `/proyecto/.dockerignore`:

```bash
cat > /proyecto/.dockerignore <<'EOF'
.git
capturas
*.log
README.md
EOF
```

Aplica permisos seguros y valida:

```bash
chmod 644 /proyecto/Dockerfile /proyecto/.dockerignore
ls -l /proyecto/Dockerfile /proyecto/.dockerignore
grep -F 'LABEL maintainer="Grupo 7 - ISL135"' /proyecto/Dockerfile
grep -F 'COPY web/ /usr/share/nginx/html/' /proyecto/Dockerfile
```

No uses `chmod 777`.

### Evidencia `F06_01_dockerfile.png`

Captura el comando completo y la salida de:

- `Dockerfile`;
- `.dockerignore`;
- permisos;
- contenido del Grupo 7 en `web/index.html`.

## Punto de control 3 — Construir la imagen

Desde `/proyecto`:

```bash
docker build -t servidor-grupo7 .
```

La primera construcción puede tardar. El proceso debe terminar con
`naming to docker.io/library/servidor-grupo7:latest` o un mensaje equivalente,
sin errores.

Verifica la imagen:

```bash
docker images --filter reference=servidor-grupo7
docker image inspect -f 'Imagen={{index .RepoTags 0}} | ID={{.Id}}' servidor-grupo7
```

El nombre debe ser `servidor-grupo7:latest`. El nombre de imagen debe estar en
minúsculas.

### Evidencia `F06_02_build_imagen.png`

Captura el comando `docker build`, su cierre correcto y las dos verificaciones
de la imagen.

## Punto de control 4 — Ejecutar y verificar

Ejecuta el contenedor:

```bash
docker run -d \
  --name nginx-personalizado \
  --restart unless-stopped \
  -p 8081:80 \
  servidor-grupo7
```

Debe devolver un ID de contenedor de 64 caracteres y no
`port is already allocated`.

Verifica contenedor, puerto y política:

```bash
docker ps --filter name=nginx-personalizado --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker port nginx-personalizado
docker inspect -f 'RestartPolicy={{.HostConfig.RestartPolicy.Name}}' nginx-personalizado
```

Criterios:

- imagen `servidor-grupo7`;
- estado `Up`;
- `0.0.0.0:8081->80/tcp`;
- `RestartPolicy=unless-stopped`.

Verifica HTTP y contenido:

```bash
curl -I http://localhost:8081
curl -fsS http://localhost:8081 | grep -F 'Grupo 7'
docker exec nginx-personalizado grep -F 'Grupo 7' /usr/share/nginx/html/index.html
```

Debe aparecer `HTTP/1.1 200 OK` y el texto `Grupo 7`. La última comprobación
demuestra que el sitio está dentro de la imagen, no en un bind mount.

Comprueba montajes y logs:

```bash
docker inspect -f '{{json .Mounts}}' nginx-personalizado
docker logs --tail 20 nginx-personalizado
```

La salida de `.Mounts` debe ser `[]`. Los logs no deben contener `emerg`,
`error` ni `crit`.

Desde el navegador del host abre:

```text
http://localhost:8081
```

Debe mostrarse el sitio del Grupo 7 con la etiqueta «Servidor en línea».

### Evidencia `F06_03_navegador_8081.png`

Captura la URL completa y la página del Grupo 7 en el puerto `8081`.

## Punto de control 5 — Comparar 8080 y 8081

Comprueba ambos puertos:

```bash
for p in 8080 8081; do
  curl -sS -o /dev/null -w "$p HTTP %{http_code}\n" "http://localhost:$p"
done
```

Debe aparecer:

```text
8080 HTTP 200
8081 HTTP 200
```

Compara el origen del contenido:

```bash
docker inspect -f 'Imagen={{.Config.Image}} | Mounts={{json .Mounts}}' nginx-basico
docker inspect -f 'Imagen={{.Config.Image}} | Mounts={{json .Mounts}}' nginx-personalizado
```

Diferencia que debes poder explicar:

| Aspecto | `8080` (`nginx-basico`) | `8081` (`nginx-personalizado`) |
|---|---|---|
| Imagen | `nginx:latest` oficial | `servidor-grupo7` construida |
| Contenido | bind mount de `/proyecto/web` | copia dentro de la imagen con `COPY` |
| Cambiar el sitio | Editar `/proyecto/web` y recargar | Reconstruir la imagen y recrear el contenedor |
| Persistencia | Depende del directorio del host | Depende de la imagen |
| Montajes | `/proyecto/web` en solo lectura | Ninguno (`[]`) |
| Uso típico | Desarrollo | Distribución reproducible |

### Evidencia `F06_04_comparacion.png`

Captura:

- dos respuestas `HTTP 200`;
- imagen y montaje de `nginx-basico`;
- imagen y montajes vacíos de `nginx-personalizado`.

## Punto de control 6 — Evidencias y cierre

Crea la carpeta de evidencias:

```bash
mkdir -p /proyecto/capturas/F06
```

Copia desde el host las capturas `F06_01` a `F06_04` a:

```text
adminsys@127.0.0.1:/proyecto/capturas/F06/
```

Revisa cambios y prepara el contenido de la fase:

```bash
cd /proyecto
git status --short
git add Dockerfile .dockerignore capturas/F06
git diff --cached --stat
git diff --cached --check
git commit -m "Fase 6: imagen personalizada servidor-grupo7 en 8081"
git push
git status --short --branch
```

El estado debe quedar `## main...origin/main`, sin cambios.

Crea el snapshot desde una terminal del host:

```bash
VBoxManage snapshot "Debian 13" take "06-imagen"
VBoxManage snapshot "Debian 13" list
```

Captura el resultado como `F06_05_snapshot.png`, cópialo a
`/proyecto/capturas/F06/` y publícalo:

```bash
cd /proyecto
git add capturas/F06/F06_05_snapshot.png
git diff --cached --stat
git commit -m "Fase 6: evidencia snapshot 06-imagen"
git push
git status --short --branch
```

## Solución de problemas

| Síntoma | Causa probable | Comprobación |
|---|---|---|
| `Cannot connect to the Docker daemon` | Servicio detenido | `sudo systemctl status docker` |
| `permission denied` al usar Docker | Grupo `docker` no activo | `id -nG` y reconectar la sesión |
| `port is already allocated` | Otro proceso usa `8081` | `sudo ss -ltnp \| grep ':8081'` |
| `COPY failed` o web no encontrado | Construcción fuera de `/proyecto` | `cd /proyecto` y `ls web/index.html` |
| `HTTP 404` o sitio vacío | Imagen construida sin `web/` | Revisar `COPY` y reconstruir |
| Los cambios del HTML no aparecen en `8081` | El contenido está dentro de la imagen | Reconstruir y recrear el contenedor |
| Imagen no encontrada | Construcción fallida o nombre incorrecto | `docker images --filter reference=servidor-grupo7` |
