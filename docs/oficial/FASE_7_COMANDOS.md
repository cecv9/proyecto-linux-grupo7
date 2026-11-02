# Fase 7 — Red `red-proyecto` y volumen `volumen-web`

> Proyecto Final ISL135 · Grupo 7 · VM `Debian 13`
>
> Esta guía comienza después de verificar la Fase 6. Los comandos se ejecutan
> como `adminsys` mediante SSH, uno a la vez. Las capturas se guardan en
> `/proyecto/capturas/F07/`. El usuario conserva el control exclusivo de la VM
> y ejecuta desde el host los comandos `VBoxManage`.

## Estado de esta guía

- [x] Punto de control 1: prevalidar identidad, Docker, Git, Fase 6 y puertos
- [x] Punto de control 2: crear y verificar `red-proyecto`
- [x] Punto de control 3: ejecutar y verificar `nginx-red` en `8082`
- [x] Punto de control 4: crear y verificar `volumen-web`
- [x] Punto de control 5: ejecutar `nginx-volumen` en `8083`
- [x] Punto de control 6: recrear el contenedor y demostrar persistencia
- [x] Punto de control 7: cerrar evidencias, Git y snapshot `07-red-volumen`

> **Fase 7 completada el 30/10/2026.** La red `red-proyecto` contiene
> `nginx-red` (`172.18.0.2/16`) y `nginx-volumen` (`172.18.0.3/16`). El
> volumen `volumen-web` conservó el sitio y el testigo
> `persistencia=2026-10-31T03:07:51Z Grupo 7` después de recrear el
> contenedor. Los cuatro puertos responden `HTTP 200`. Se publicaron 49
> evidencias en los commits `cfb5da5` y `32b85e7`; el snapshot
> `07-red-volumen` tiene UUID
> `1abb2246-6b24-4780-8bf9-f592df9d0fab`.

## Evidencias previstas

| Archivo | Contenido obligatorio |
|---|---|
| `F07_01_red_custom.png` | Red `red-proyecto`, controlador bridge y `nginx-red` con IPv4 |
| `F07_02_navegador_8082.png` | Sitio del Grupo 7 en `http://localhost:8082` |
| `F07_03_volumen.png` | `volumen-web` montado en `nginx-volumen` y archivos internos |
| `F07_04_persistencia_8083.png` | Sitio y archivo persistente después de recrear el contenedor |
| `F07_05_snapshot.png` | Snapshot `07-red-volumen` creado y listado |

Se pueden conservar capturas adicionales para documentar cada comando y sus
resultados.

## Punto de control 1 — Prevalidación

### 1. Identidad y grupo Docker

```bash
id
```

Criterios:

- usuario `adminsys`;
- grupo primario `adminsys`;
- grupo `docker` presente.

### 2. Servicio Docker y contenedores de las fases anteriores

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
```

Deben aparecer:

```text
nginx-basico         nginx:latest       Up ... 0.0.0.0:8080->80/tcp
nginx-personalizado  servidor-grupo7    Up ... 0.0.0.0:8081->80/tcp
```

### 3. Respuestas HTTP de las fases anteriores

```bash
for p in 8080 8081; do curl -sS -o /dev/null -w "$p HTTP %{http_code}\n" "http://localhost:$p"; done
```

Resultado esperado:

```text
8080 HTTP 200
8081 HTTP 200
```

### 4. Git sincronizado

```bash
cd /proyecto && git status --short --branch
```

Resultado esperado:

```text
## main...origin/main
```

### 5. Nombres y puertos de la Fase 7 libres

```bash
docker ps -a --filter name=nginx-red --filter name=nginx-volumen
```

No debe aparecer ningún contenedor.

```bash
sudo ss -ltnp | grep -E ':808[23]' || echo "Puertos 8082 y 8083 libres"
```

Resultado esperado:

```text
Puertos 8082 y 8083 libres
```

También se debe comprobar que la red y el volumen aún no existen:

```bash
docker network ls --filter name=red-proyecto
docker volume ls --filter name=volumen-web
```

En ambos casos solo debe aparecer la línea de encabezado. Si ya existe un
objeto de un intento anterior, no se elimina sin revisar primero que no
contenga datos necesarios.

## Punto de control 2 — Crear `red-proyecto`

```bash
docker network create --driver bridge red-proyecto
docker network ls --filter name=red-proyecto
```

Debe aparecer `red-proyecto` con controlador `bridge`.

```bash
docker network inspect red-proyecto
```

Criterios:

- `"Name": "red-proyecto"`;
- `"Driver": "bridge"`;
- `"Scope": "local"`;
- subred privada asignada automáticamente;
- `"Containers": {}` antes de ejecutar Nginx.

## Punto de control 3 — Ejecutar y verificar `nginx-red`

```bash
docker run -d \
  --name nginx-red \
  --restart unless-stopped \
  --network red-proyecto \
  -p 8082:80 \
  -v /proyecto/web:/usr/share/nginx/html:ro \
  nginx:latest
```

Verificar el contenedor:

```bash
docker ps --filter name=nginx-red --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker inspect -f 'Red={{range $k,$v := .NetworkSettings.Networks}}{{$k}} {{$v.IPAddress}}{{end}} | Reinicio={{.HostConfig.RestartPolicy.Name}} | Montaje={{range .Mounts}}{{.Source}}->{{.Destination}} RW={{.RW}}{{end}}' nginx-red
```

Criterios:

- estado `Up`;
- `0.0.0.0:8082->80/tcp`;
- red `red-proyecto`;
- IPv4 privada de la subred;
- política `unless-stopped`;
- montaje `/proyecto/web` en solo lectura (`RW=false`).

Verificar la red y el sitio:

```bash
docker network inspect red-proyecto --format '{{range .Containers}}{{.Name}} -> {{.IPv4Address}}{{println}}{{end}}'
curl -I http://localhost:8082
curl -fsS http://localhost:8082 | grep -F 'Grupo 7'
docker logs --tail 20 nginx-red
```

Los logs no deben contener `emerg`, `error` ni `crit`.

### Evidencias del punto de control 3

1. `F07_01_red_custom.png`: `network inspect` con `nginx-red` y su IPv4.
2. `F07_02_navegador_8082.png`: `http://localhost:8082` mostrando el sitio del
   Grupo 7.

## Punto de control 4 — Crear `volumen-web`

```bash
docker volume create volumen-web
docker volume ls --filter name=volumen-web
docker volume inspect volumen-web
```

Criterios:

- nombre exacto `volumen-web`;
- controlador `local`;
- punto de montaje administrado por Docker bajo
  `/var/lib/docker/volumes/volumen-web/_data`.

## Punto de control 5 — Ejecutar `nginx-volumen`

```bash
docker run -d \
  --name nginx-volumen \
  --restart unless-stopped \
  --network red-proyecto \
  -p 8083:80 \
  -v volumen-web:/usr/share/nginx/html \
  nginx:latest
```

Copiar el sitio al volumen:

```bash
docker cp /proyecto/web/index.html nginx-volumen:/usr/share/nginx/html/index.html
docker cp /proyecto/web/favicon.svg nginx-volumen:/usr/share/nginx/html/favicon.svg
```

Verificar contenedor, volumen y sitio:

```bash
docker ps --filter name=nginx-volumen --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker inspect -f 'Montaje={{range .Mounts}}{{.Type}} {{.Name}} -> {{.Destination}} RW={{.RW}}{{end}}' nginx-volumen
docker exec nginx-volumen ls -l /usr/share/nginx/html
curl -I http://localhost:8083
curl -fsS http://localhost:8083 | grep -F 'Grupo 7'
docker logs --tail 20 nginx-volumen
```

Criterios:

- estado `Up`;
- `0.0.0.0:8083->80/tcp`;
- tipo de montaje `volume`;
- nombre `volumen-web`;
- destino `/usr/share/nginx/html`;
- `index.html` y `favicon.svg` presentes;
- respuesta `HTTP/1.1 200 OK`;
- texto `Grupo 7` presente.

### Evidencia del punto de control 5

`F07_03_volumen.png` debe mostrar:

- `docker volume inspect volumen-web`;
- montaje nombrado de `nginx-volumen`;
- `ls` interno con los archivos del sitio.

## Punto de control 6 — Demostrar persistencia

Crear un testigo con fecha dentro del volumen:

```bash
docker exec nginx-volumen sh -c 'date -u +"persistencia=%Y-%m-%dT%H:%M:%SZ Grupo 7" > /usr/share/nginx/html/persistencia.txt && cat /usr/share/nginx/html/persistencia.txt'
```

Guardar el contenedor y el testigo antes de eliminarlo:

```bash
docker inspect -f '{{.Id}}' nginx-volumen
docker exec nginx-volumen cat /usr/share/nginx/html/persistencia.txt
```

Eliminar solo el contenedor; el volumen no se elimina:

```bash
docker rm -f nginx-volumen
```

Comprobar que el volumen continúa existiendo:

```bash
docker volume inspect volumen-web
```

Volver a crear el contenedor usando el mismo volumen:

```bash
docker run -d \
  --name nginx-volumen \
  --restart unless-stopped \
  --network red-proyecto \
  -p 8083:80 \
  -v volumen-web:/usr/share/nginx/html \
  nginx:latest
```

Comprobar la persistencia después de la recreación:

```bash
docker exec nginx-volumen cat /usr/share/nginx/html/persistencia.txt
curl -sS -o /dev/null -w '8083 HTTP %{http_code}\n' http://localhost:8083
curl -fsS http://localhost:8083 | grep -F 'Grupo 7'
```

El testigo debe conservar la fecha creada antes de eliminar el contenedor y el
puerto `8083` debe volver a responder `HTTP 200`.

Desde el navegador del host abrir:

```text
http://localhost:8083
```

### Evidencia del punto de control 6

`F07_04_persistencia_8083.png` debe mostrar:

- testigo antes de eliminar el contenedor;
- contenedor eliminado;
- volumen todavía presente;
- testigo después de recrear el contenedor;
- respuesta del sitio en `8083`.

## Punto de control 7 — Evidencias, Git y snapshot

Crear la carpeta de evidencias en la VM:

```bash
mkdir -p /proyecto/capturas/F07
```

Desde el host, copiar las capturas a la VM. Ajustar claramente el origen:

```bash
scp -P 2222 /RUTA/LOCAL/F07_*.png adminsys@127.0.0.1:/proyecto/capturas/F07/
```

Revisar los archivos y preparar el cierre:

```bash
ls -l /proyecto/capturas/F07
cd /proyecto
git status --short
git add capturas/F07
git diff --cached --stat
git diff --cached --check
git commit -m "Fase 7: red personalizada y volumen persistente"
git push
git status --short --branch
```

El estado debe quedar limpio y sincronizado.

El usuario crea el snapshot desde el host:

```bash
VBoxManage snapshot "Debian 13" take "07-red-volumen"
VBoxManage snapshot "Debian 13" list
```

Capturar el resultado como `F07_05_snapshot.png`, copiarlo a la VM y
versionarlo:

```bash
cd /proyecto
git add capturas/F07/F07_05_snapshot.png
git diff --cached --stat
git commit -m "Fase 7: evidencia snapshot 07-red-volumen"
git push
git status --short --branch
```

## Verificación final de la Fase 7

```bash
docker network inspect red-proyecto --format '{{.Name}} | {{.Driver}} | {{range .Containers}}{{.Name}}={{.IPv4Address}} {{end}}'
docker volume inspect volumen-web --format '{{.Name}} | {{.Driver}} | {{.Mountpoint}}'
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
for p in 8080 8081 8082 8083; do curl -sS -o /dev/null -w "$p HTTP %{http_code}\n" "http://localhost:$p"; done
cd /proyecto && git status --short --branch
```

Criterios finales:

- `red-proyecto` contiene `nginx-red` y `nginx-volumen`;
- `volumen-web` está montado por `nginx-volumen`;
- los cuatro contenedores están activos y publican `8080` a `8083`;
- los cuatro puertos responden HTTP `200`;
- el testigo de persistencia sobrevive a la recreación del contenedor;
- Git está limpio y sincronizado;
- snapshot `07-red-volumen` creado y documentado.

## Comparación técnica y conclusión

| Técnica | Dónde están los datos | Persistencia | Ventaja principal | Uso en el proyecto |
|---|---|---|---|---|
| Contenido copiado en la imagen | Capa de la imagen | Permanece al recrear el contenedor con la misma imagen; requiere rebuild para actualizar el sitio | Distribución reproducible | `8081`, `servidor-grupo7` |
| Bind mount | `/proyecto/web` en la VM | Depende de la ruta del host | Edición directa y desarrollo rápido | `8080` y `8082` |
| Volumen nombrado | Administrado por Docker en `/var/lib/docker/volumes/volumen-web/_data` | Independiente del ciclo de vida del contenedor | Portabilidad y gestión con Docker | `8083` |
| Red bridge predeterminada | Configuración implícita de Docker | N/A | Conexión sencilla sin configuración adicional | `nginx-basico` y `nginx-personalizado` |
| Red bridge personalizada | Red `red-proyecto`, subred `172.18.0.0/16` | N/A | Aislamiento y resolución DNS por nombre | `nginx-red` y `nginx-volumen` |

La prueba confirma dos diferencias importantes:

1. `nginx-red` obtiene conectividad y resolución interna por pertenecer a
   `red-proyecto`, mientras conserva el sitio del host mediante un bind mount
   de solo lectura.
2. `nginx-volumen` puede eliminarse y recrearse sin perder los archivos porque
   el volumen `volumen-web` existe fuera del contenedor. El testigo
   `persistencia=2026-10-31T03:07:51Z Grupo 7` apareció con la misma marca
   antes y después de la recreación.

Cuando un volumen está vacío, Docker copia al volumen el contenido inicial de
la imagen en la ruta de montaje; por eso también apareció `50x.html`. El sitio
del Grupo 7 fue copiado después con `docker cp` y permaneció en el volumen.
