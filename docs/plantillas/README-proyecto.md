# proyecto-linux-grupo1

Servidor Linux automatizado con Docker para el **Proyecto Final de Introducción al
Software Libre (ISL135)**.

## Integrantes

| Nombre | Usuario de GitHub | Fase principal |
|---|---|---|
| Nombre 1 | @usuario1 | 1 |
| Nombre 2 | @usuario2 | 2–3 |
| Nombre 3 | @usuario3 | 4–5 |
| Nombre 4 | @usuario4 | 6–8 |

## Descripción

El proyecto implementa una máquina virtual Debian 13 con Docker que sirve cuatro
sitios Nginx en los puertos 8080–8083, automatiza un reporte del sistema con cron y
versiona todo el código en GitHub.

## Arquitectura

| Puerto | Contenedor | Técnica demostrada |
|---|---|---|
| 8080 | `nginx-basico` | Bind mount de `/proyecto/web` |
| 8081 | `nginx-personalizado` | Imagen propia construida con Dockerfile |
| 8082 | `nginx-red` | Red definida por el usuario `red-proyecto` |
| 8083 | `nginx-volumen` | Volumen persistente `volumen-web` |

## Estructura

```text
/proyecto/
├── datos/                 # configuración
├── web/                   # sitio (index.html)
├── scripts/               # reporte_sistema.sh, verificar_proyecto.sh
├── capturas/              # evidencias
├── Dockerfile
├── .dockerignore
├── .gitignore
└── README.md
```

## Requisitos

- Debian 13 (VM VirtualBox)
- Docker Engine y complementos
- Git
- Nginx (imagen de Docker)

## Instalación

1. Crear la VM y actualizar el sistema.
2. Configurar hostname, usuarios, grupos y permisos (fase 1).
3. Instalar el script y cron (fase 2).
4. Inicializar el repositorio Git en `/proyecto` y enlazar el remoto (fase 3).
5. Instalar Docker y ejecutar `hello-world` (fase 4).
6. Crear los contenedores de las fases 5–7.
7. Verificar con `scripts/verificar_proyecto.sh` (fase 8).

Los comandos exactos están documentados en el informe del proyecto.

## Uso

```bash
docker ps
curl -I http://localhost:8080
curl -I http://localhost:8081
curl -I http://localhost:8082
curl -I http://localhost:8083
```

## Automatización

`reporte_sistema.sh` se ejecuta cada 30 minutos mediante `/etc/cron.d/proyecto` y
escribe en `/var/log/proyecto/reporte_sistema.log`.

## Evidencias

Las capturas del informe están en `capturas/`.

## Seguridad

Este repositorio no contiene contraseñas, tokens ni claves. El grupo `docker` se usa
solo en el laboratorio; en producción se recomienda Docker rootless.

## Licencia

Uso académico — Universidad de El Salvador, 2026.
