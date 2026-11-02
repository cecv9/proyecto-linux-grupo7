# Fase 06 — Imagen personalizada con Dockerfile

## Objetivo

Construir una imagen propia y compararla con la imagen oficial de Nginx.

## Qué se hizo

Se creó el `Dockerfile` con `FROM nginx:latest`, `COPY web/ /usr/share/nginx/html/`, `EXPOSE 80` y `CMD ["nginx", "-g", "daemon off;"]`. Se construyó la imagen `servidor-grupo7`, se ejecutó `nginx-personalizado` en el puerto `8081` y se comparó con `nginx-basico`: la imagen propia lleva el contenido dentro y no depende de un montaje del host.

## Comandos principales

```bash
cd /proyecto
docker build -t servidor-grupo7 .
docker run -d --name nginx-personalizado --restart unless-stopped \
  -p 8081:80 servidor-grupo7
curl -I http://localhost:8081
docker inspect -f '{json .Mounts}' nginx-personalizado
```

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F06_00_prevalidacion.png`](F06_00_prevalidacion.png) | Comprobación previa. |
| [`F06_01_dockerfile.png`](F06_01_dockerfile.png) | Dockerfile personalizado del proyecto. |
| [`F06_01a_dockerfile.png`](F06_01a_dockerfile.png) | Dockerfile del proyecto. |
| [`F06_02_build_imagen.png`](F06_02_build_imagen.png) | Construcción de la imagen servidor-grupo7. |
| [`F06_02a_build.png`](F06_02a_build.png) | Build de la imagen. |
| [`F06_03_navegador_8081.png`](F06_03_navegador_8081.png) | Sitio servido desde la imagen propia en 8081. |
| [`F06_03a_container_run.png`](F06_03a_container_run.png) | Ejecución del contenedor. |
| [`F06_03b_contenedor.png`](F06_03b_contenedor.png) | Contenedor. |
| [`F06_03c_http_contenido.png`](F06_03c_http_contenido.png) | Contenido servido por HTTP. |
| [`F06_03d_montaje_logs.png`](F06_03d_montaje_logs.png) | Montaje y logs. |
| [`F06_04_comparacion.png`](F06_04_comparacion.png) | Comparación entre Nginx oficial y la imagen personalizada. |
| [`F06_05_snapshot.png`](F06_05_snapshot.png) | Snapshot. |

## Resultado

La imagen es autocontenida y reproducible; el puerto 8081 funciona sin bind mount.
