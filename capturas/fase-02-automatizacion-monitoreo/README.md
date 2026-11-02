# Fase 02 — Automatización y monitoreo

## Objetivo

Registrar el estado del servidor sin intervención humana.

## Qué se hizo

Se creó `reporte_sistema.sh`, que muestra fecha y hora, hostname, usuarios conectados, espacio libre en disco, RAM disponible y cantidad de contenedores Docker activos. El script tiene permisos de ejecución y contempla el caso de que Docker no esté instalado o el daemon esté detenido. La tarea `/etc/cron.d/proyecto` lo ejecuta cada 30 minutos y agrega la salida a `/var/log/proyecto/reporte_sistema.log`.

## Comandos principales

```bash
chmod 755 /proyecto/scripts/reporte_sistema.sh
bash -n /proyecto/scripts/reporte_sistema.sh
/proyecto/scripts/reporte_sistema.sh
sudo systemctl enable --now cron
sudo cat /etc/cron.d/proyecto
tail -n 30 /var/log/proyecto/reporte_sistema.log
```

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F02_01_salida.txt`](F02_01_salida.txt) | Salida completa del reporte del sistema. |
| [`F02_01_script.png`](F02_01_script.png) | Script reporte_sistema.sh con permisos de ejecución. |
| [`F02_02_cron.png`](F02_02_cron.png) | Tarea /etc/cron.d/proyecto programada cada 30 minutos. |
| [`F02_03_log.png`](F02_03_log.png) | Log /var/log/proyecto/reporte_sistema.log actualizándose. |
| [`F02_04_snapshot.png`](F02_04_snapshot.png) | Snapshot de cierre de la fase 2. |

## Resultado

El estado del servidor queda registrado cada 30 minutos, aunque nadie esté conectado.
