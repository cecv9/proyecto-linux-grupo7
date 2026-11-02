# Fase 01 — Administración básica, usuarios y permisos

## Objetivo

Dar identidad al servidor y separar los roles de administración, soporte y visitantes.

## Qué se hizo

Se configuró el hostname `servidor-grupo7`, se crearon los usuarios `adminsys`, `tecnico` y `visitante`, y los grupos `soporte` y `web`. `adminsys` quedó con `sudo`, `tecnico` en `soporte` y `visitante` en `web`. También se creó `/proyecto/{datos,web,scripts,capturas}`, se asignó `datos` al grupo `soporte`, `web` al grupo `web` y se activó el bit setgid (`2775`) para que los archivos nuevos hereden el grupo del directorio.

## Comandos principales

```bash
sudo hostnamectl set-hostname servidor-grupo7
sudo adduser adminsys
sudo adduser tecnico
sudo adduser visitante
sudo addgroup soporte
sudo addgroup web
sudo usermod -aG sudo adminsys
sudo usermod -aG soporte tecnico
sudo usermod -aG web visitante
sudo mkdir -p /proyecto/{datos,web,scripts,capturas}
sudo chown adminsys:adminsys /proyecto
sudo chgrp soporte /proyecto/datos
sudo chgrp web /proyecto/web
sudo chmod 2775 /proyecto/datos /proyecto/web
```

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F01_01_hostname.png`](F01_01_hostname.png) | Hostname permanente servidor-grupo7 y resolución en /etc/hosts. |
| [`F01_02_usuarios_grupos.png`](F01_02_usuarios_grupos.png) | Creación de adminsys, tecnico, visitante y de los grupos soporte y web. |
| [`F01_03_sudo.png`](F01_03_sudo.png) | Comprobación de que adminsys pertenece al grupo sudo. |
| [`F01_04_directorios_permisos.png`](F01_04_directorios_permisos.png) | Estructura /proyecto y permisos de datos y web. |
| [`F01_05_herencia.png`](F01_05_herencia.png) | Prueba de herencia de grupo gracias al setgid 2775. |

## Resultado

Cada rol tiene acceso a lo que le corresponde y la herencia de grupo queda garantizada por el setgid.
