# Fase 2 — Automatización y monitoreo

> Proyecto Final ISL135 · Grupo 7 · VM `Debian 13`
>
> Ejecuta los bloques en este orden. Detente si un punto de control no coincide
> con lo indicado y corrige ese bloque antes de continuar.

## Punto de control 0 — Conectar y entrar como `adminsys`

Desde el host:

```bash
ssh -F /dev/null -p 2222 debian@127.0.0.1
```

Dentro de la VM:

```bash
hostname
su - adminsys
whoami
test -d /proyecto/scripts && echo "OK: /proyecto/scripts existe"
```

Resultado esperado:

```text
servidor-grupo7
adminsys
OK: /proyecto/scripts existe
```

No continúes si `whoami` no devuelve `adminsys`.

## Punto de control 1 — Crear el script

Copia todo este bloque en la sesión de `adminsys`:

```bash
cat > /proyecto/scripts/reporte_sistema.sh <<'EOF'
#!/usr/bin/env bash
#
# reporte_sistema.sh - Reporte básico del servidor
# Proyecto final ISL135 - Grupo 7
#
# Muestra: fecha/hora, hostname, usuarios conectados, disco, RAM y
# contenedores Docker activos. Pensado para ejecutarse por cron cada 30 min.
#
set -u

FECHA="$(date '+%Y-%m-%d %H:%M:%S')"
HOST="$(hostname)"
USUARIOS="$(who | wc -l)"

DISCO_TOTAL="$(df -h / | awk 'NR==2 {print $2}')"
DISCO_LIBRE="$(df -h / | awk 'NR==2 {print $4}')"
DISCO_USO="$(df -h / | awk 'NR==2 {print $5}')"

RAM_TOTAL="$(free -h | awk '/^Mem:/ {print $2}')"
RAM_DISPONIBLE="$(free -h | awk '/^Mem:/ {print $7}')"

if ! command -v docker >/dev/null 2>&1; then
    CONTENEDORES="Docker no instalado"
elif ! docker info >/dev/null 2>&1; then
    CONTENEDORES="No disponible (daemon detenido o sin permiso)"
else
    CONTENEDORES="$(docker ps -q | wc -l)"
fi

echo "=================================================="
echo " REPORTE DEL SISTEMA - ${FECHA}"
echo "=================================================="
printf " Hostname................: %s\n" "${HOST}"
printf " Usuarios conectados.....: %s\n" "${USUARIOS}"
printf " Disco principal.........: %s libres de %s (%s usado)\n" "${DISCO_LIBRE}" "${DISCO_TOTAL}" "${DISCO_USO}"
printf " RAM disponible..........: %s de %s\n" "${RAM_DISPONIBLE}" "${RAM_TOTAL}"
printf " Contenedores Docker.....: %s\n" "${CONTENEDORES}"
echo "=================================================="
EOF
```

Asigna permisos y valida la sintaxis:

```bash
chmod 755 /proyecto/scripts/reporte_sistema.sh
bash -n /proyecto/scripts/reporte_sistema.sh
```

Resultado esperado: `bash -n` no imprime nada y termina con código 0.

Punto de control de los seis datos:

```bash
grep -E 'FECHA|HOST|USUARIOS|DISCO_TOTAL|RAM_TOTAL|CONTENEDORES' /proyecto/scripts/reporte_sistema.sh
```

## Punto de control 2 — Probar manualmente y capturar `F02_01`

```bash
ls -l /proyecto/scripts/reporte_sistema.sh
/proyecto/scripts/reporte_sistema.sh
```

Antes de instalar Docker, el reporte debe mostrar:

- fecha y hora;
- `Hostname................: servidor-grupo7`;
- `Usuarios conectados`;
- `Disco principal`;
- `RAM disponible`;
- `Contenedores Docker.....: Docker no instalado`.

Evidencia `F02_01_script.png`: captura que incluya la ejecución manual completa
y el resultado de `ls -l`. Guárdala en `/proyecto/capturas/`.

## Punto de control 3 — Preparar cron y el log

```bash
sudo apt install -y cron
sudo systemctl enable --now cron
systemctl is-enabled cron
systemctl is-active cron
```

Los dos últimos comandos deben devolver `enabled` y `active`.

Crea el directorio y el archivo del log:

```bash
sudo mkdir -p /var/log/proyecto
sudo chown root:adminsys /var/log/proyecto
sudo chmod 775 /var/log/proyecto
sudo touch /var/log/proyecto/reporte_sistema.log
sudo chown root:adminsys /var/log/proyecto/reporte_sistema.log
sudo chmod 664 /var/log/proyecto/reporte_sistema.log
```

Crea la tarea de cron:

```bash
sudo tee /etc/cron.d/proyecto > /dev/null <<'EOF'
# Reporte del sistema cada 30 minutos - Proyecto ISL135
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
*/30 * * * * root /proyecto/scripts/reporte_sistema.sh >> /var/log/proyecto/reporte_sistema.log 2>&1
EOF
sudo chown root:root /etc/cron.d/proyecto
sudo chmod 644 /etc/cron.d/proyecto
sudo systemctl restart cron
```

Verifica los permisos y la programación:

```bash
cat /etc/cron.d/proyecto
stat -c '%U:%G %a %n' /etc/cron.d/proyecto /var/log/proyecto /var/log/proyecto/reporte_sistema.log
systemctl status cron --no-pager
```

Resultados esperados:

- `/etc/cron.d/proyecto`: `root:root 644`;
- `/var/log/proyecto`: `root:adminsys 775`;
- log: `root:adminsys 664`;
- cron `active (running)`;
- línea de programación `*/30 * * * * root ...`.

Evidencia `F02_02_cron.png`: captura con `cat /etc/cron.d/proyecto` y
`systemctl status cron --no-pager`.

## Punto de control 4 — Probar cron sin esperar media hora

Guarda una copia de seguridad de la programación definitiva:

```bash
sudo cp -a /etc/cron.d/proyecto /tmp/proyecto.cron.30min
```

Cambia temporalmente la frecuencia a cada minuto, reinicia y espera:

```bash
sudo sed -i 's#^\*/30 #* #' /etc/cron.d/proyecto
sudo systemctl restart cron
date '+Inicio de prueba: %Y-%m-%d %H:%M:%S'
sleep 75
sudo tail -n 30 /var/log/proyecto/reporte_sistema.log
```

Resultado esperado: al menos un bloque `REPORTE DEL SISTEMA`.

Restaura inmediatamente la programación de 30 minutos:

```bash
sudo cp -a /tmp/proyecto.cron.30min /etc/cron.d/proyecto
sudo chown root:root /etc/cron.d/proyecto
sudo chmod 644 /etc/cron.d/proyecto
sudo systemctl restart cron
cat /etc/cron.d/proyecto
grep '^\*/30 ' /etc/cron.d/proyecto
```

El último comando debe mostrar exactamente la línea `*/30` una vez.

## Punto de control 5 — Demostrar dos ejecuciones reales separadas ~30 min

Cron se ejecuta en los minutos `00` y `30`. Vuelve a revisar el log después de
que hayan ocurrido dos de esos minutos:

```bash
date '+Revisión: %Y-%m-%d %H:%M:%S'
grep 'REPORTE DEL SISTEMA' /var/log/proyecto/reporte_sistema.log | tail -n 6
sudo tail -n 30 /var/log/proyecto/reporte_sistema.log
sudo journalctl -u cron --since "90 min ago" --no-pager
```

La fase NO está completa hasta que el log contenga al menos dos ejecuciones
reales con una separación aproximada de 30 minutos. Las entradas de la prueba
de cada minuto no sustituyen esa comprobación.

Evidencia `F02_03_log.png`: captura de `grep` y `tail` con dos marcas de tiempo
reales separadas aproximadamente 30 minutos, después de haber restaurado `*/30`.

## Punto de control 6 — Snapshot final

Ejecuta desde el host, no dentro de la VM:

```bash
VBoxManage snapshot "Debian 13" take "02-fase2"
VBoxManage snapshot "Debian 13" list
```

Si el snapshot ya existe, no lo reemplaces ni lo elimines; comprueba primero
con `VBoxManage snapshot "Debian 13" list`.

Evidencia recomendada `F02_04_snapshot.png`: captura de la lista que muestre el
snapshot `02-fase2`.

## Cierre

Antes de pasar a la fase 3, todas estas afirmaciones deben ser ciertas:

- `reporte_sistema.sh` es ejecutable y muestra los seis datos;
- `/etc/cron.d/proyecto` contiene `*/30` y es de `root:root 644`;
- `cron` está activo y habilitado;
- el log es de `root:adminsys 664` y crece con las ejecuciones de cron;
- hay dos ejecuciones reales separadas aproximadamente 30 minutos;
- `F02_01`, `F02_02` y `F02_03` están en `/proyecto/capturas/`;
- el snapshot `02-fase2` existe.
