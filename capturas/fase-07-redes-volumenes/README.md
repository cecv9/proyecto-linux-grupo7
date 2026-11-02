# Fase 07 — Redes y volúmenes de Docker

## Objetivo

Aislar servicios en una red propia y conservar contenido en un volumen persistente.

## Qué se hizo

Se creó la red `red-proyecto` y el contenedor `nginx-red` en el puerto `8082`; se comprobó con `docker network inspect` que está conectado. También se creó el volumen `volumen-web` y el contenedor `nginx-volumen` en el puerto `8083`; se copió el sitio al volumen y se demostró que el contenido sobrevive al eliminar y recrear el contenedor.

## Comandos principales

```bash
docker network create red-proyecto
docker run -d --name nginx-red --restart unless-stopped \
  --network red-proyecto -p 8082:80 nginx:latest
docker volume create volumen-web
docker run -d --name nginx-volumen --restart unless-stopped \
  -p 8083:80 -v volumen-web:/usr/share/nginx/html nginx:latest
docker network inspect red-proyecto
docker volume inspect volumen-web
docker cp /proyecto/web/index.html nginx-volumen:/usr/share/nginx/html/index.html
docker cp /proyecto/web/favicon.svg nginx-volumen:/usr/share/nginx/html/favicon.svg
```

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F07_00_contenedor_antes_recrear.png`](F07_00_contenedor_antes_recrear.png) | Contenedor antes de recrear. |
| [`F07_00_contenedor_ausente.png`](F07_00_contenedor_ausente.png) | Contenedor ausente. |
| [`F07_00_contenedor_eliminado.png`](F07_00_contenedor_eliminado.png) | Contenedor eliminado. |
| [`F07_00_contenido_8082.png`](F07_00_contenido_8082.png) | Contenido servido en 8082. |
| [`F07_00_contenido_8083.png`](F07_00_contenido_8083.png) | Contenido servido en 8083. |
| [`F07_00_contenido_8083_recreado.png`](F07_00_contenido_8083_recreado.png) | Contenido en 8083 tras recrear. |
| [`F07_00_cp_favicon.png`](F07_00_cp_favicon.png) | Copia de favicon.svg al volumen. |
| [`F07_00_cp_index.png`](F07_00_cp_index.png) | Copia de index.html al volumen. |
| [`F07_00_creacion_red.png`](F07_00_creacion_red.png) | Creación de la red personalizada. |
| [`F07_00_http_8082.png`](F07_00_http_8082.png) | Respuesta HTTP en 8082. |
| [`F07_00_http_8083.png`](F07_00_http_8083.png) | Respuesta HTTP en 8083. |
| [`F07_00_http_8083_recreado.png`](F07_00_http_8083_recreado.png) | Respuesta HTTP en 8083 tras recrear. |
| [`F07_00_http_final.png`](F07_00_http_final.png) | Respuesta HTTP final. |
| [`F07_00_logs_8082.png`](F07_00_logs_8082.png) | Logs del contenedor 8082. |
| [`F07_00_logs_8083.png`](F07_00_logs_8083.png) | Logs del contenedor 8083. |
| [`F07_00_ls_volumen.png`](F07_00_ls_volumen.png) | Contenido del volumen. |
| [`F07_00_nginx_red_creado.png`](F07_00_nginx_red_creado.png) | Contenedor nginx-red creado. |
| [`F07_00_nginx_red_estado.png`](F07_00_nginx_red_estado.png) | Estado de nginx-red. |
| [`F07_00_nginx_red_inspect.png`](F07_00_nginx_red_inspect.png) | Inspección de nginx-red. |
| [`F07_00_nginx_volumen_creado.png`](F07_00_nginx_volumen_creado.png) | Contenedor nginx-volumen creado. |
| [`F07_00_nginx_volumen_inspect.png`](F07_00_nginx_volumen_inspect.png) | Inspección de nginx-volumen. |
| [`F07_00_nginx_volumen_recreado.png`](F07_00_nginx_volumen_recreado.png) | Contenedor nginx-volumen recreado. |
| [`F07_00_prevalidacion_01_identidad.png`](F07_00_prevalidacion_01_identidad.png) | Comprobación previa: identidad del usuario. |
| [`F07_00_prevalidacion_02_contenedores.png`](F07_00_prevalidacion_02_contenedores.png) | Comprobación previa: contenedores activos. |
| [`F07_00_prevalidacion_03_http_previos.png`](F07_00_prevalidacion_03_http_previos.png) | Comprobación previa: respuestas HTTP anteriores. |
| [`F07_00_prevalidacion_04_git.png`](F07_00_prevalidacion_04_git.png) | Comprobación previa: estado de Git. |
| [`F07_00_prevalidacion_05_nombres_libres.png`](F07_00_prevalidacion_05_nombres_libres.png) | Comprobación previa: nombres de contenedores libres. |
| [`F07_00_prevalidacion_06_puertos_libres.png`](F07_00_prevalidacion_06_puertos_libres.png) | Comprobación previa: puertos libres. |
| [`F07_00_prevalidacion_07_red_libre.png`](F07_00_prevalidacion_07_red_libre.png) | Comprobación previa: red libre. |
| [`F07_00_prevalidacion_08_volumen_libre.png`](F07_00_prevalidacion_08_volumen_libre.png) | Comprobación previa: volumen libre. |
| [`F07_00_red_final.png`](F07_00_red_final.png) | Estado final de la red. |
| [`F07_00_red_inspect_inicial.png`](F07_00_red_inspect_inicial.png) | Inspección inicial de la red. |
| [`F07_00_red_registrada.png`](F07_00_red_registrada.png) | Red registrada. |
| [`F07_00_servicios_final.png`](F07_00_servicios_final.png) | Estado final de los servicios. |
| [`F07_00_testigo_creado.png`](F07_00_testigo_creado.png) | Archivo testigo creado en el volumen. |
| [`F07_00_testigo_despues_recrear.png`](F07_00_testigo_despues_recrear.png) | Archivo testigo después de recrear. |
| [`F07_00_volumen_creado.png`](F07_00_volumen_creado.png) | Volumen creado. |
| [`F07_00_volumen_despues_eliminar.png`](F07_00_volumen_despues_eliminar.png) | Estado del volumen después de eliminar el contenedor. |
| [`F07_00_volumen_inspect.png`](F07_00_volumen_inspect.png) | Inspección del volumen. |
| [`F07_00_volumen_registrado.png`](F07_00_volumen_registrado.png) | Volumen registrado. |
| [`F07_01_red_custom.png`](F07_01_red_custom.png) | Red personalizada red-proyecto creada. |
| [`F07_02_navegador_8082.png`](F07_02_navegador_8082.png) | Sitio servido desde nginx-red en 8082. |
| [`F07_03_volumen.png`](F07_03_volumen.png) | Volumen volumen-web creado e inspeccionado. |
| [`F07_04_navegador_8083.png`](F07_04_navegador_8083.png) | Sitio servido desde nginx-volumen en 8083. |
| [`F07_04_persistencia_8083.png`](F07_04_persistencia_8083.png) | Persistencia del contenido después de recrear el contenedor. |
| [`F07_05_snapshot.png`](F07_05_snapshot.png) | Snapshot. |
| [`F07_05_snapshot_creacion.png`](F07_05_snapshot_creacion.png) | Creación del snapshot. |
| [`F07_05_snapshot_listado.png`](F07_05_snapshot_listado.png) | Listado de snapshots. |
| [`_F07_04_navegador_8083_sin_url.png`](_F07_04_navegador_8083_sin_url.png) | Navegador 8083 sin URL. |

## Resultado

Los contenedores se comunican por nombre y el contenido del volumen persiste aunque el contenedor se recree.
