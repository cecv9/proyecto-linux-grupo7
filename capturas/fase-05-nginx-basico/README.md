# Fase 05 — Servidor web Nginx básico

## Objetivo

Publicar el sitio del proyecto en el puerto 8080 con un bind mount.

## Qué se hizo

Se creó el sitio en `/proyecto/web/index.html`, se ejecutó `nginx-basico` en segundo plano con `-d`, se mapeó el puerto `8080` del host al `80` del contenedor y se montó `/proyecto/web` en `/usr/share/nginx/html` en modo solo lectura. Se verificó la respuesta HTTP y se revisaron los logs.

## Comandos principales

```bash
docker run -d --name nginx-basico --restart unless-stopped \
  -p 8080:80 -v /proyecto/web:/usr/share/nginx/html:ro nginx:latest
curl -I http://localhost:8080
docker logs --tail 20 nginx-basico
docker inspect -f '{range .Mounts}{.Source} -> {.Destination}{"\n"}{end}' nginx-basico
```

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F05_01_contenedor.png`](F05_01_contenedor.png) | Contenedor nginx-basico en ejecución. |
| [`F05_01a_docker_ps.png`](F05_01a_docker_ps.png) | Contenedores activos con docker ps. |
| [`F05_01b_docker_port.png`](F05_01b_docker_port.png) | Puerto publicado con docker port. |
| [`F05_01c_politica_reinicio.png`](F05_01c_politica_reinicio.png) | Política de reinicio del contenedor. |
| [`F05_02_navegador.png`](F05_02_navegador.png) | Sitio del proyecto visible en http://localhost:8080. |
| [`F05_03_logs_montaje.png`](F05_03_logs_montaje.png) | Logs y montaje del contenedor. |
| [`F05_03a_http.png`](F05_03a_http.png) | HTTP. |
| [`F05_03b_montaje.png`](F05_03b_montaje.png) | Montaje del contenedor. |
| [`F05_03c_logs_limpios.png`](F05_03c_logs_limpios.png) | Logs sin errores. |
| [`F05_04_snapshot.png`](F05_04_snapshot.png) | Snapshot. |

## Resultado

El sitio se sirve desde el host y los cambios en `/proyecto/web` se reflejan sin reconstruir la imagen.
