# Fase 00 — Preparación del entorno

## Objetivo

Partir de una base limpia, actualizada y reproducible antes de configurar el servidor.

## Qué se hizo

Se actualizó Debian 13, se instalaron las herramientas base (`curl`, `git`, `vim`, `wget`, `nano`, `cron` y `openssh-server`), se configuró la zona horaria `America/El_Salvador`, se verificaron red, SSH y paquetes, y se tomó el snapshot `00-base-instalada`.

## Comandos principales

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git vim wget nano cron openssh-server
sudo timedatectl set-timezone America/El_Salvador
hostnamectl
ip a
systemctl status ssh --no-pager
sudo dpkg --audit
```

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F00_01_actualizacion.png`](F00_01_actualizacion.png) | Actualización de paquetes del sistema con apt. |
| [`F00_02_reinicio.png`](F00_02_reinicio.png) | Reinicio de la máquina virtual después de actualizar. |
| [`F00_03_herramientas.png`](F00_03_herramientas.png) | Instalación de curl, git, vim, wget, nano, cron y openssh-server. |
| [`F00_04_entorno_base.png`](F00_04_entorno_base.png) | Resumen del entorno base: hostname, red, SSH y paquetes. |
| [`F00_05_snapshot.png`](F00_05_snapshot.png) | Snapshot 00-base-instalada tomado desde VirtualBox. |
| [`_F00_04a_timezone.png`](_F00_04a_timezone.png) | Configuración de la zona horaria. |
| [`_F00_04b_debian.png`](_F00_04b_debian.png) | Versión de Debian. |
| [`_F00_04c_hostname.png`](_F00_04c_hostname.png) | Configuración y verificación del hostname. |
| [`_F00_04d_red.png`](_F00_04d_red.png) | Configuración de red. |
| [`_F00_04e_ssh.png`](_F00_04e_ssh.png) | Servicio SSH. |
| [`_F00_04f_dpkg_audit.png`](_F00_04f_dpkg_audit.png) | Dpkg audit. |

## Resultado

El entorno quedó listo y con un punto de restauración para revertir cambios si algo falla.
