# Guía paso a paso — Servidor Linux automatizado con Docker

> **Proyecto Final ISL135 · Grupo 7 · Debian 13 · Docker · VirtualBox**
>
> Esta guía se ejecuta **dentro de la VM**. Sigue las fases en orden, verifica cada
> bloque y captura la evidencia antes de continuar. Si algo falla, no avances: usa
> el apéndice de solución de problemas.

---

## Convenciones

- Se usa el **grupo 1** como ejemplo. Cambia `1` por tu número de grupo en:
  `servidor-grupo7`, `proyecto-linux-grupo7` y `servidor-grupo7` (imagen Docker).
- Los comandos se ejecutan como `adminsys` desde la fase 3, salvo que se indique `sudo`.
- Las capturas se guardan en `/proyecto/capturas/` con el nombre `F0X_NN_descripcion.png`.
- Cada fase termina con **verificación**, **evidencia** y **snapshot**.

> **Regla de oro sobre los snapshots:** todos los comandos `VBoxManage` se ejecutan
> **en el host Debian**, nunca dentro de la VM. Si estás conectado por SSH a la VM,
> usa la interfaz gráfica de VirtualBox en el host o abre una terminal del host.
> Dentro de la VM no existe `VBoxManage`.
>
> En los ejemplos se usa `"Debian 13"` como nombre de la VM. Si tu máquina
> en VirtualBox se llama `"Debian 13"`, reemplaza ese nombre en **todos** los
> comandos `VBoxManage`.

> **Decisión recomendada:** para este proyecto es suficiente una VM Debian 13
> **sin escritorio**, administrada por SSH, y usar el navegador del host para abrir
> los puertos 8080–8083. Reduce el tamaño del OVA y evita instalar XFCE. Si tu
> docente exige navegar dentro de la VM, instala XFCE más adelante; no es necesario
> para cumplir el enunciado.

### Mapa de la guía

| Fase | Qué haces | Puerto/servicio |
|---|---|---|
| 0 | Preparar la VM y el sistema base | SSH 22 |
| 1 | Hostname, usuarios, grupos, directorios y permisos | — |
| 2 | Script de monitoreo y cron cada 30 min | — |
| 3 | Git local y repositorio en GitHub | — |
| 4 | Instalar Docker y probar `hello-world` | — |
| 5 | Nginx oficial con bind mount | 8080 |
| 6 | Dockerfile e imagen propia | 8081 |
| 7 | Red personalizada y volumen persistente | 8082 / 8083 |
| 8 | Pruebas de conectividad y verificación integral | 8080–8083 |

---

# Fase 0 — Preparar la VM

Si aún no has creado la VM, sigue primero `02_VM_EXPORTAR_IMPORTAR.md`. La configuración recomendada es:

| Recurso | Valor |
|---|---|
| Sistema | Debian 13 (netinst, sin escritorio; recomendado) |
| RAM | 3072 MB mínimo; 4096 MB recomendado |
| CPU | 2 vCPU mínimo |
| Disco | 25 GB VDI dinámico mínimo |
| Red | NAT con reenvío 2222→22 y 8080–8083→8080–8083 |
| Usuario inicial | `enoc` con sudo |
| SSH | `ssh -p 2222 enoc@127.0.0.1` desde el host |

> **Tu VM actual:** la máquina llamada `Debian 13` ya tiene 4 CPU, 8 GB de RAM y
> 64 GB de disco. Supera los mínimos, así que **no necesitas crear otra**. Lo que
> falta es configurar los reenvíos NAT que se explican en `02_VM_EXPORTAR_IMPORTAR.md`.
> El nombre visible de la VM (`Debian 13`) no es el hostname del sistema; el
> hostname que se configura en la fase 1 será `servidor-grupo7`.

### 0.1 Revisar los reenvíos NAT antes de empezar

En el **host**, con la VM apagada, comprueba si existen las reglas:

```bash
# [HOST] No ejecutar dentro de la VM
VM="Debian 13"
VBoxManage showvminfo "$VM" --machinereadable | grep -i Forwarding
```

Si no aparece ninguna regla `2222`, `8080`, `8081`, `8082` o `8083`, créalas así:

```bash
# [HOST] Reemplaza "Debian 13" por el nombre exacto de tu VM.
VM="Debian 13"

# Elimina solo reglas del proyecto si ya existen, para no duplicarlas.
for r in proyecto-ssh proyecto-web8080 proyecto-web8081 proyecto-web8082 proyecto-web8083; do
  VBoxManage modifyvm "$VM" --natpf1 delete "$r" 2>/dev/null || true
done

VBoxManage modifyvm "$VM" --natpf1 "proyecto-ssh,tcp,,2222,,22"
VBoxManage modifyvm "$VM" --natpf1 "proyecto-web8080,tcp,,8080,,8080"
VBoxManage modifyvm "$VM" --natpf1 "proyecto-web8081,tcp,,8081,,8081"
VBoxManage modifyvm "$VM" --natpf1 "proyecto-web8082,tcp,,8082,,8082"
VBoxManage modifyvm "$VM" --natpf1 "proyecto-web8083,tcp,,8083,,8083"

VBoxManage showvminfo "$VM" --machinereadable | grep -i Forwarding
```

La salida debe contener las cinco reglas. Si no aparecen, no continúes con la
exportación: el OVA se exportaría sin acceso a los puertos.

Dentro de la VM, actualiza e instala las herramientas base:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y curl wget git vim nano cron openssh-server ca-certificates gnupg
sudo systemctl enable --now ssh
sudo timedatectl set-timezone America/El_Salvador
```

Si `apt full-upgrade` instaló un kernel nuevo, reinicia antes de continuar:

```bash
sudo reboot
```

Verifica:

```bash
cat /etc/debian_version        # debe empezar con 13.
hostname
ip -4 addr show
systemctl is-active ssh
```

Toma el primer snapshot desde el host (con la VM apagada o en caliente):

```bash
# [HOST] VirtualBox Manager o terminal del host
VBoxManage snapshot "Debian 13" take "00-base-instalada"
```

> **Evidencia F00:** `cat /etc/debian_version`, `ip -4 addr show` y el snapshot en la interfaz de VirtualBox.

---

# Fase 1 — Preparación del entorno servidor

**Objetivo:** cumplir los puntos 1.1 y 1.2 del enunciado: hostname, tres usuarios, dos grupos, sudo y estructura de directorios con herencia de grupo.

## 1.1 Nombre del host

```bash
sudo hostnamectl set-hostname servidor-grupo7
```

Asegura la resolución local en `/etc/hosts`:

```bash
grep -q '^127\.0\.1\.1' /etc/hosts || printf '127.0.1.1\tservidor-grupo7\n' | sudo tee -a /etc/hosts > /dev/null
sudo sed -i 's/^127\.0\.1\.1.*/127.0.1.1\tservidor-grupo7/' /etc/hosts
```

Verifica:

```bash
hostnamectl
hostname
hostname -f
getent hosts servidor-grupo7
```

Salida esperada: `Static hostname: servidor-grupo7` y `127.0.1.1 servidor-grupo7`.

**Por qué funciona:** `hostnamectl` escribe el hostname estático en `/etc/hostname` y systemd lo aplica; `/etc/hosts` permite resolver el nombre localmente aunque no haya DNS.

> **Evidencia F01_01:** captura de `hostnamectl` y `getent hosts servidor-grupo7`.

## 1.2 Crear usuarios y grupos

Crea los tres usuarios (te pedirá contraseña y datos opcionales; puedes dejar vacíos los campos de nombre y oficina):

```bash
sudo adduser adminsys
sudo adduser tecnico
sudo adduser visitante
```

> El enunciado escribe «técnico» con tilde, pero Linux no admite tildes en nombres de usuario. Se crea `tecnico` y se explica en el informe.
>
> `enoc` es la cuenta de instalación y recuperación; los tres usuarios del
> proyecto son `adminsys`, `tecnico` y `visitante`. Si el docente exige
> exactamente tres cuentas, crea la VM usando `adminsys` como usuario inicial y
> omite `sudo adduser adminsys` (deberás ajustar el acceso SSH del resto de la guía).

Crea los grupos:

```bash
sudo groupadd soporte
sudo groupadd web
```

Asigna usuarios a grupos:

```bash
sudo usermod -aG sudo adminsys
sudo usermod -aG soporte tecnico
sudo usermod -aG web visitante
```

Verifica:

```bash
id adminsys
id tecnico
id visitante
getent group soporte web sudo
```

Salida esperada (los números pueden variar):

```text
uid=1001(adminsys) gid=1001(adminsys) groups=1001(adminsys),27(sudo)
uid=1002(tecnico)  gid=1002(tecnico)  groups=1002(tecnico),1004(soporte)
uid=1003(visitante) gid=1003(visitante) groups=1003(visitante),1005(web)
```

Prueba que `adminsys` puede usar sudo:

```bash
su - adminsys
sudo whoami        # debe imprimir: root
exit
```

**Por qué funciona:** `-aG` agrega el grupo **sin eliminar** los grupos secundarios existentes. Los cambios de grupo se aplican al iniciar una sesión nueva; por eso hay que salir y volver a entrar (o usar `newgrp`).

> **Evidencia F01_02:** `id` de los tres usuarios y `getent group`.
> **Evidencia F01_03:** `sudo whoami` ejecutado como `adminsys`.

## 1.3 Estructura de directorios y permisos

Crea la estructura:

```bash
sudo mkdir -p /proyecto/{datos,web,scripts,capturas}
```

Asigna propietario y grupos:

```bash
sudo chown -R adminsys:adminsys /proyecto
sudo chgrp soporte /proyecto/datos
sudo chgrp web /proyecto/web
sudo chmod 2775 /proyecto/datos /proyecto/web
sudo chmod 775 /proyecto/scripts /proyecto/capturas
```

Verifica:

```bash
ls -ld /proyecto /proyecto/*
```

Salida esperada:

```text
drwxr-xr-x 6 adminsys adminsys /proyecto
drwxrwsr-x 2 adminsys soporte  /proyecto/datos
drwxrwsr-x 2 adminsys web      /proyecto/web
drwxrwxr-x 2 adminsys adminsys /proyecto/scripts
drwxrwxr-x 2 adminsys adminsys /proyecto/capturas
```

La **`s`** en el grupo de `datos` y `web` es el bit **setgid**. Hace que todo archivo o subdirectorio nuevo herede el grupo del directorio padre.

Prueba la herencia con los usuarios reales:

```bash
sudo -u tecnico -i bash -c 'echo "prueba de herencia" > /proyecto/datos/prueba_tecnico.txt'
sudo -u visitante -i bash -c 'echo "prueba de herencia" > /proyecto/web/prueba_visitante.txt'
ls -l /proyecto/datos/prueba_tecnico.txt /proyecto/web/prueba_visitante.txt
```

Salida esperada: el grupo de `prueba_tecnico.txt` es `soporte` y el de `prueba_visitante.txt` es `web`.

Limpia las pruebas:

```bash
sudo rm -f /proyecto/datos/prueba_tecnico.txt /proyecto/web/prueba_visitante.txt
```

### Alternativa con ACL (opcional, para el informe)

Si quieres demostrar otra técnica, instala `acl` y define ACL por defecto:

```bash
sudo apt install -y acl
sudo setfacl -d -m g:soporte:rwx /proyecto/datos
sudo setfacl -d -m g:web:rwx /proyecto/web
getfacl /proyecto/datos
```

No es necesario si usas setgid; el enunciado se cumple con `2775`.

**Por qué 2775 y no 777:** `777` daría escritura a cualquier usuario del sistema; `2775` permite escritura al propietario y al grupo, lectura/ejecución a los demás, y activa setgid. Es el equilibrio correcto entre funcionalidad y seguridad.

> **Evidencia F01_04:** `ls -ld /proyecto/*` mostrando la `s`.
> **Evidencia F01_05:** archivo creado por `tecnico` con grupo `soporte` y archivo creado por `visitante` con grupo `web`.

> **A partir de aquí, todo el trabajo dentro de `/proyecto` se hace como `adminsys`**, porque es el propietario de la carpeta. En la fase 2 cambiarás a ese usuario.

Toma el snapshot `01-fase1`:

```bash
# [HOST] no ejecutar dentro de la VM
VBoxManage snapshot "Debian 13" take "01-fase1"
```

---

# Fase 2 — Automatización y monitoreo

**Objetivo:** script `reporte_sistema.sh` con los seis datos que pide el enunciado y tarea cron cada 30 minutos que escribe en `/var/log/proyecto/reporte_sistema.log`.

> **Cambia a `adminsys`** (propietario de `/proyecto`) antes de crear archivos:
>
> ```bash
> su - adminsys
> whoami    # debe imprimir: adminsys
> ```
>
> Si ya estás como `adminsys`, omite el `su`.

## 2.1 Crear el script

Crea el archivo (puedes usar `nano` o el heredoc tal cual):

```bash
cat > /proyecto/scripts/reporte_sistema.sh <<'EOF'
#!/usr/bin/env bash
#
# reporte_sistema.sh - Reporte básico del servidor
# Proyecto final ISL135 - Grupo 7
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

Da permisos de ejecución y valida la sintaxis:

```bash
chmod 755 /proyecto/scripts/reporte_sistema.sh
bash -n /proyecto/scripts/reporte_sistema.sh
```

Ejecuta:

```bash
/proyecto/scripts/reporte_sistema.sh
```

Salida esperada (antes de instalar Docker):

```text
==================================================
 REPORTE DEL SISTEMA - 2026-10-19 21:40:00
==================================================
 Hostname................: servidor-grupo7
 Usuarios conectados.....: 1
 Disco principal.........: 18G libres de 25G (28% usado)
 RAM disponible..........: 1.9Gi de 3.9Gi
 Contenedores Docker.....: Docker no instalado
==================================================
```

**Qué hace cada parte:**

- `date` → fecha y hora actual.
- `hostname` → nombre del host.
- `who | wc -l` → sesiones conectadas.
- `df -h /` → espacio del sistema de archivos raíz (`$4` = disponible, `$2` = total, `$5` = porcentaje).
- `free -h` → memoria; la columna 7 es «available» (disponible real, no solo libre).
- `docker ps -q | wc -l` → contenedores en ejecución. El `if` evita errores antes de instalar Docker.

> **Evidencia F02_01:** ejecución manual del script con la salida completa.

## 2.2 Configurar cron

Instala y habilita el servicio (en instalaciones mínimas puede no estar activo):

```bash
sudo apt install -y cron
sudo systemctl enable --now cron
systemctl status cron --no-pager
```

Crea el directorio del log:

```bash
sudo mkdir -p /var/log/proyecto
sudo chown root:adminsys /var/log/proyecto
sudo chmod 775 /var/log/proyecto
sudo touch /var/log/proyecto/reporte_sistema.log
sudo chown root:adminsys /var/log/proyecto/reporte_sistema.log
sudo chmod 664 /var/log/proyecto/reporte_sistema.log
```

Con estos permisos, `adminsys` puede revisar el log sin `sudo`; cron seguirá
escribiendo como `root`.

Crea la tarea en `/etc/cron.d/proyecto`:

```bash
sudo tee /etc/cron.d/proyecto > /dev/null <<'EOF'
# Reporte del sistema cada 30 minutos - Proyecto ISL135
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
*/30 * * * * root /proyecto/scripts/reporte_sistema.sh >> /var/log/proyecto/reporte_sistema.log 2>&1
EOF
sudo chown root:root /etc/cron.d/proyecto
sudo chmod 644 /etc/cron.d/proyecto
```

Verifica:

```bash
cat /etc/cron.d/proyecto
sudo systemctl restart cron
```

El formato de una línea de cron es:

```text
minuto  hora  día-del-mes  mes  día-de-la-semana  usuario  comando
*/30    *     *            *    *                 root     /proyecto/scripts/...
```

`*/30` significa «en los minutos 0 y 30 de cada hora». El archivo en `/etc/cron.d` lleva el **usuario** (`root`) porque es un cron del sistema; el crontab personal no lo lleva.

### Probar sin esperar 30 minutos

Cambia temporalmente la frecuencia a cada minuto:

```bash
sudo sed -i 's#^\*/30 #* #' /etc/cron.d/proyecto
sudo systemctl restart cron
sleep 75
sudo tail -n 30 /var/log/proyecto/reporte_sistema.log
```

Si apareció al menos una entrada, cron funciona. Restaura la frecuencia:

```bash
sudo sed -i 's#^\* #*/30 #' /etc/cron.d/proyecto
sudo systemctl restart cron
cat /etc/cron.d/proyecto
```

> Espera 30–60 minutos y vuelve a revisar el log: debe haber una segunda entrada con una diferencia aproximada de 30 minutos. Esa es la prueba real de la fase 2.2.

**Solución de problemas:**

| Problema | Causa | Solución |
|---|---|---|
| El log no existe | Cron no ejecutó | `systemctl status cron`; `journalctl -u cron --since "10 min ago"` |
| El log está vacío | Script sin permisos o con error | Ejecuta el script a mano; `bash -n`; revisa `2>&1` |
| Funciona a mano pero no en cron | `PATH` incompleto | Usa rutas absolutas y define `PATH` en el cron |
| Error de fin de línea | Archivo con CRLF | `dos2unix /proyecto/scripts/reporte_sistema.sh` |

> **Evidencia F02_02:** `cat /etc/cron.d/proyecto` y `systemctl status cron`.
> **Evidencia F02_03:** `tail` del log con una o dos entradas y la marca de tiempo.

**Snapshot `02-fase2`:** ejecútalo en el host, no dentro de la VM.

```bash
# [HOST]
VBoxManage snapshot "Debian 13" take "02-fase2"
```

---

# Fase 3 — Control de versiones

**Objetivo:** repositorio Git en `/proyecto`, primer commit, repositorio remoto `proyecto-linux-grupo7` en GitHub, README y commits de los cuatro integrantes.

## 3.1 Preparar Git y el repositorio local

Continúa como `adminsys` (si cerraste la sesión, vuelve a entrar):

```bash
su - adminsys
whoami          # adminsys
cd /proyecto
```

> Si ya estás como `adminsys`, omite `su - adminsys`.

Instala Git si no está:

```bash
sudo apt install -y git
```

Inicializa el repositorio:

```bash
cd /proyecto
git init -b main
```

Configura tu identidad (cada integrante debe hacerlo antes de su commit; el comando debe ejecutarse dentro del repositorio):

```bash
git config user.name "Nombre del integrante"
git config user.email "correo@github"
```

Crea `.gitignore`:

```bash
cat > /proyecto/.gitignore <<'EOF'
*.log
*.tmp
.env
.DS_Store
*.ova
*.vdi
*.iso
.docker/
EOF
```

Crea archivos testigo para que Git conserve las carpetas vacías:

```bash
touch /proyecto/datos/.gitkeep /proyecto/web/.gitkeep /proyecto/capturas/.gitkeep
```

> **No crees todavía el README.** El PDF pide primero el commit de la estructura,
> luego crear el repositorio remoto y subirlo, y **posteriormente** crear el
> `README.md`. El README se agrega al final de esta sección, después del primer
> `git push`.

Primer commit:

```bash
cd /proyecto
git add .
git status
git commit -m "Estructura inicial: directorios, permisos, script y cron"
git log --oneline --graph
```

> **Evidencia F03_01:** `git log --oneline --graph`.

## 3.2 Crear el repositorio remoto en GitHub

1. Entra a <https://github.com> con tu cuenta.
2. **New repository** → nombre `proyecto-linux-grupo7`.
3. Visibilidad: pública (recomendado para la entrega) o privada con colaboradores.
4. **No** marques «Add a README», «.gitignore» ni licencia: el README se crea después del primer push, como pide el PDF.
5. Crea el repositorio.

### Autenticación por SSH (recomendada)

Como `adminsys`:

```bash
ssh-keygen -t ed25519 -C "correo@github"
cat ~/.ssh/id_ed25519.pub
```

Copia la clave pública y pégala en GitHub: **Settings → SSH and GPG keys → New SSH key**.

Prueba:

```bash
ssh -T git@github.com
```

Es normal que el mensaje termine con «successfully authenticated» aunque el comando devuelva código 1.

Conecta el remoto y sube:

```bash
cd /proyecto
git remote add origin git@github.com:USUARIO/proyecto-linux-grupo7.git
git branch -M main
git push -u origin main
```

### Alternativa por HTTPS con token

GitHub ya no acepta la contraseña de la cuenta. Crea un **Personal Access Token** (Settings → Developer settings → Personal access tokens) con permiso `repo` y úsalo como contraseña:

> Usa **una sola** de las dos formas de autenticación. Si eliges HTTPS, ejecuta
> este bloque en lugar de «Conecta el remoto y sube» de la sección SSH y después
> continúa con «Crear el README después del primer push». No ejecutes
> `git remote add` dos veces.

```bash
git remote add origin https://github.com/USUARIO/proyecto-linux-grupo7.git
git push -u origin main
# Usuario: USUARIO
# Contraseña: el token (no la contraseña de GitHub)
```

### Crear el README después del primer push

Con el remoto ya configurado y la estructura subida, crea y sube el README en un
commit separado:

```bash
cat > /proyecto/README.md <<'EOF'
# proyecto-linux-grupo7

Servidor Linux automatizado con Docker — Proyecto Final ISL135.

## Integrantes
- Nombre 1
- Nombre 2
- Nombre 3
- Nombre 4

## Tecnologías
Debian 13, Docker, Nginx, Bash, cron, Git y GitHub.

## Estructura
- `datos/`: archivos de configuración.
- `web/`: sitio servido por Nginx.
- `scripts/`: automatización.
- `capturas/`: evidencias del proyecto.
- `Dockerfile`: imagen personalizada.

## Puertos
| Puerto | Servicio |
|---|---|
| 8080 | Nginx con bind mount |
| 8081 | Imagen personalizada |
| 8082 | Nginx en red-proyecto |
| 8083 | Nginx con volumen-web |

## Instalación
Consulta la guía del proyecto y ejecuta las fases en orden.

## Scripts
- `scripts/reporte_sistema.sh`: reporte del sistema.
EOF

cd /proyecto
git add README.md
git commit -m "docs: agregar README del proyecto"
git push
```

> **Evidencia F03_02:** `git remote -v` y `git push` exitoso.
> **Evidencia F03_03:** pantalla del repositorio en GitHub con los archivos.

## 3.3 Trabajo en equipo y commits de los cuatro

Agrega a los demás como colaboradores si el repo es privado (**Settings → Collaborators**).

Cada integrante clona el repositorio **en su propio equipo o en su propia VM**.
No lo clones dentro de `/proyecto`, porque crearías un repositorio Git anidado:

```bash
cd ~
git clone git@github.com:USUARIO/proyecto-linux-grupo7.git
cd proyecto-linux-grupo7
git config user.name "Nombre"
git config user.email "correo@github"
```

Flujo por fase (recomendado):

```bash
git switch -c fase-6-dockerfile
# ... cambios ...
git add .
git commit -m "Fase 6: Dockerfile e imagen personalizada"
git push -u origin fase-6-dockerfile
```

Luego se abre un **Pull Request** en GitHub y otro integrante lo revisa y lo fusiona. Antes de empezar una rama:

```bash
git switch main
git pull --rebase
```

Verifica que todos aportaron:

```bash
git log --format='%h | %an | %s' --all
```

> **Evidencia F03_04:** `git log` mostrando al menos un commit por integrante.
> **Evidencia F03_05:** Pull Request fusionado (opcional, suma presentación).

**Errores frecuentes:**

- `Permission denied (publickey)` → la clave pública no está en GitHub o estás usando otra cuenta.
- `Updates were rejected` → haz `git pull --rebase` antes de `push`.
- Archivos propiedad de root → `sudo chown -R adminsys:adminsys /proyecto`.
- Nunca subas contraseñas, tokens ni claves privadas. Si ocurre, cambia la contraseña/token y elimina el archivo del historial.

**Snapshot `03-git`:** ejecútalo en el host.

```bash
# [HOST]
VBoxManage snapshot "Debian 13" take "03-git"
```

---

# Fase 4 — Docker

**Objetivo:** instalar Docker, habilitar el servicio, agregar `adminsys` y `tecnico` al grupo `docker`, ejecutar `hello-world` y listar contenedores.

## 4.1 Instalar Docker desde el repositorio oficial

Como `adminsys`:

```bash
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Agrega el repositorio (usa el nombre clave de Debian, `trixie` en Debian 13):

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

> **Alternativa con los repositorios de Debian:** `sudo apt install -y docker.io docker-compose-v2`. No mezcles ambas instalaciones.

Habilita e inicia el servicio:

```bash
sudo systemctl enable --now docker
systemctl is-active docker
sudo docker version
sudo docker info
```

**Por qué funciona:** el paquete instala el daemon `dockerd`, el cliente `docker` y `containerd`. `enable --now` hace que arranque también en cada reinicio.

## 4.2 Agregar usuarios al grupo docker

```bash
sudo usermod -aG docker adminsys
sudo usermod -aG docker tecnico
getent group docker
```

Debes ver algo como `docker:x:999:adminsys,tecnico`.

Aplica el cambio iniciando una sesión nueva:

```bash
exit                 # vuelve a enoc
su - adminsys
docker ps            # sin sudo; no debe dar "permission denied"
```

También puedes usar `newgrp docker` en la sesión actual.

Verifica al otro usuario:

```bash
sudo -u tecnico -i docker ps
```

**Por qué se hace así:** el socket `/var/run/docker.sock` pertenece a `root:docker`. Pertenecer al grupo permite usarlo sin `sudo`. Es cómodo, pero equivale a privilegios de root: quien pueda usar Docker puede montar el sistema de archivos del host. Anótalo en las conclusiones del informe.

## 4.3 Verificación inicial con hello-world

```bash
docker run hello-world
docker ps -a
docker images
```

- `docker run` descarga la imagen si no está local, crea un contenedor, lo ejecuta y muestra el mensaje.
- `docker ps` muestra solo contenedores **en ejecución**; `hello-world` ya terminó, por eso aparece con `docker ps -a`.
- `docker images` lista las imágenes descargadas.

> **Evidencia F04_01:** `docker version` / `docker info`.
> **Evidencia F04_02:** `getent group docker` e `id adminsys` / `id tecnico`.
> **Evidencia F04_03:** salida completa de `hello-world`, `docker ps -a` y `docker images`.

**Snapshot `04-docker`:** ejecútalo en el host.

```bash
# [HOST]
VBoxManage snapshot "Debian 13" take "04-docker"
```

---

# Fase 5 — Servidor web con contenedor Nginx (8080)

**Objetivo:** crear `index.html`, ejecutar Nginx en segundo plano, mapear 8080→80 y montar `/proyecto/web` en `/usr/share/nginx/html`.

## 5.1 Crear el sitio

Como `adminsys`:

```bash
cat > /proyecto/web/index.html <<'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Proyecto ISL135 · Grupo 7</title>
  <style>
    :root { --azul:#0b3d91; --claro:#f4f7fb; --texto:#1f2937; }
    * { box-sizing: border-box; }
    body { margin:0; font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
           color:var(--texto); background:var(--claro); line-height:1.6; }
    header { background:linear-gradient(135deg, #0b3d91, #1565c0); color:#fff;
             padding:3rem 1.5rem; text-align:center; }
    header h1 { margin:0 0 .5rem; font-size:2rem; }
    header p { margin:.25rem 0; opacity:.9; }
    main { max-width:900px; margin:2rem auto; padding:0 1.25rem; }
    .card { background:#fff; border-radius:12px; padding:1.5rem 1.75rem; margin-bottom:1.25rem;
            box-shadow:0 4px 14px rgba(15,23,42,.08); }
    h2 { color:var(--azul); margin-top:0; }
    code { background:#eef2ff; padding:.15rem .4rem; border-radius:4px; font-size:.95em; }
    footer { text-align:center; padding:1.5rem; color:#64748b; font-size:.9rem; }
    .badge { display:inline-block; background:#dcfce7; color:#166534; padding:.2rem .7rem;
             border-radius:999px; font-size:.85rem; font-weight:600; }
  </style>
</head>
<body>
  <header>
    <span class="badge">Servidor en línea</span>
    <h1>Proyecto Final ISL135</h1>
    <p>Servidor Linux automatizado con Docker</p>
    <p>Grupo 7 · Ciclo II–2026</p>
  </header>
  <main>
    <section class="card">
      <h2>¿Qué estás viendo?</h2>
      <p>Este sitio se sirve desde un contenedor Nginx dentro de una máquina virtual
         Debian 13. El contenido se monta desde <code>/proyecto/web</code> y se
         publica en el puerto <code>8080</code> del host.</p>
    </section>
    <section class="card">
      <h2>Servicios del proyecto</h2>
      <ul>
        <li><strong>8080:</strong> Nginx oficial con bind mount del sitio.</li>
        <li><strong>8081:</strong> imagen personalizada <code>servidor-grupo7</code>.</li>
        <li><strong>8082:</strong> Nginx en la red <code>red-proyecto</code>.</li>
        <li><strong>8083:</strong> Nginx con el volumen <code>volumen-web</code>.</li>
      </ul>
    </section>
    <section class="card">
      <h2>Automatización</h2>
      <p>El script <code>reporte_sistema.sh</code> se ejecuta cada 30 minutos mediante
         cron y registra el estado del servidor en
         <code>/var/log/proyecto/reporte_sistema.log</code>.</p>
    </section>
  </main>
  <footer>
    Universidad de El Salvador · Facultad Multidisciplinaria de Occidente<br>
    Introducción al Software Libre · 2026
  </footer>
</body>
</html>
EOF
```

Verifica permisos y contenido:

```bash
ls -l /proyecto/web/index.html     # grupo web, lectura para todos
chmod 664 /proyecto/web/index.html # el grupo web puede editarlo (visitante incluido)
head -n 5 /proyecto/web/index.html
```

## 5.2 Ejecutar el contenedor

```bash
docker run -d \
  --name nginx-basico \
  --restart unless-stopped \
  -p 8080:80 \
  -v /proyecto/web:/usr/share/nginx/html:ro \
  nginx:latest
```

Explicación de cada opción:

| Opción | Significado |
|---|---|
| `-d` | Detached: el contenedor corre en segundo plano. |
| `--name nginx-basico` | Nombre fijo para identificarlo. |
| `--restart unless-stopped` | Se reinicia solo tras un reinicio de la VM, salvo que lo detengas a propósito. |
| `-p 8080:80` | Puerto 8080 del host → puerto 80 del contenedor. |
| `-v /proyecto/web:/usr/share/nginx/html:ro` | Monta el directorio del host dentro del contenedor, en modo solo lectura. |
| `nginx:latest` | Imagen oficial de Nginx. |

## 5.3 Verificar

```bash
docker ps --filter name=nginx-basico
docker port nginx-basico
curl -I http://localhost:8080
curl -s http://localhost:8080 | head -n 10
docker logs --tail 20 nginx-basico
```

Debes obtener `HTTP/1.1 200 OK` y el HTML del sitio. En el navegador del host abre:

```text
http://localhost:8080
```

**Si no funciona:**

| Síntoma | Causa | Solución |
|---|---|---|
| `403 Forbidden` | Permisos del archivo o falta `index.html` | `ls -l /proyecto/web`; `chmod 644`; verifica el nombre |
| `404 Not Found` | El mount está vacío o en otra ruta | `docker exec nginx-basico ls -l /usr/share/nginx/html` |
| `port is already allocated` | Otro proceso usa 8080 | `sudo ss -tlnp \| grep 8080`; cambia el puerto o detén el proceso |
| El contenedor reinicia | Error de configuración | `docker logs nginx-basico`; `docker inspect nginx-basico` |
| El navegador del host no abre | Reenvío NAT ausente | Revisa la regla 8080 en VirtualBox; prueba `curl` dentro de la VM |

> **Evidencia F05_01:** `docker ps` con el contenedor y el puerto.
> **Evidencia F05_02:** navegador en `http://localhost:8080`.
> **Evidencia F05_03:** `docker logs nginx-basico` sin errores.

**Snapshot `05-nginx`:** ejecútalo en el host.

```bash
# [HOST]
VBoxManage snapshot "Debian 13" take "05-nginx"
```

---

# Fase 6 — Dockerfile personalizado (8081)

**Objetivo:** construir la imagen `servidor-grupo7` con `nginx:latest`, copiar `web/` dentro de la imagen y ejecutarla en el puerto 8081.

## 6.1 Crear el Dockerfile

```bash
cat > /proyecto/Dockerfile <<'EOF'
FROM nginx:latest

LABEL maintainer="Grupo 7 - ISL135"
LABEL description="Servidor web personalizado del proyecto final"

# Copia el contenido del sitio dentro de la imagen
COPY web/ /usr/share/nginx/html/

# Documenta el puerto que expone Nginx
EXPOSE 80

# Comando de inicio de Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
EOF
```

Crea `.dockerignore` para no enviar archivos innecesarios al contexto de construcción:

```bash
cat > /proyecto/.dockerignore <<'EOF'
.git
capturas
*.log
README.md
EOF
```

## 6.2 Construir la imagen

```bash
cd /proyecto
docker build -t servidor-grupo7 .
docker images | grep -E 'servidor-grupo7|nginx'
```

> El nombre de la imagen debe ir en **minúsculas**. `docker build` usa `.` como contexto: por eso el Dockerfile debe estar en `/proyecto` y `web/` debe existir dentro de ese contexto.

**Qué hace cada instrucción:**

- `FROM nginx:latest` → parte de la imagen oficial.
- `COPY web/ /usr/share/nginx/html/` → «hornea» el sitio dentro de la imagen.
- `EXPOSE 80` → documenta el puerto (no lo publica por sí solo).
- `CMD [...]` → arranca Nginx en primer plano, que es lo que Docker necesita para mantener el contenedor vivo.

## 6.3 Ejecutar el contenedor en 8081

```bash
docker run -d \
  --name nginx-personalizado \
  --restart unless-stopped \
  -p 8081:80 \
  servidor-grupo7

docker ps --filter name=nginx-personalizado
curl -I http://localhost:8081
docker logs --tail 20 nginx-personalizado
```

Navegador del host: `http://localhost:8081`.

## 6.4 Comparar con el Nginx oficial (8080)

| Aspecto | 8080 (`nginx-basico`) | 8081 (`nginx-personalizado`) |
|---|---|---|
| Imagen | `nginx:latest` oficial | `servidor-grupo7` construida |
| Contenido | bind mount `/proyecto/web` | copia dentro de la imagen (`COPY`) |
| Actualizar el sitio | Editas el archivo y recargas el navegador | Reconstruyes la imagen y recreas el contenedor |
| Persistencia del contenido | Depende del host | Depende de la imagen |
| Tamaño | ~190 MB | Unos MB más (incluye el sitio) |
| Uso típico | Desarrollo | Distribución reproducible |

Demostración en vivo de la diferencia:

```bash
echo "<!-- editado $(date) -->" >> /proyecto/web/index.html
curl -s http://localhost:8080 | tail -n 2     # aparece el comentario
curl -s http://localhost:8081 | tail -n 2     # NO aparece
```

Reconstruye y recrea para actualizar el 8081:

```bash
docker build -t servidor-grupo7 .
docker rm -f nginx-personalizado
docker run -d --name nginx-personalizado --restart unless-stopped -p 8081:80 servidor-grupo7
curl -s http://localhost:8081 | tail -n 2     # ahora sí aparece
```

> **Evidencia F06_01:** Dockerfile.
> **Evidencia F06_02:** salida de `docker build` y `docker images`.
> **Evidencia F06_03:** navegador en `http://localhost:8081`.
> **Evidencia F06_04:** comparación 8080 vs 8081 (captura o tabla).

**Snapshot `06-imagen`:** ejecútalo en el host.

```bash
# [HOST]
VBoxManage snapshot "Debian 13" take "06-imagen"
```

---

# Fase 7 — Redes y volúmenes Docker (8082 y 8083)

**Objetivo:** crear la red `red-proyecto` y el volumen `volumen-web`; ejecutar Nginx conectado a cada uno en los puertos 8082 y 8083.

## 7.1 Red personalizada

```bash
docker network create --driver bridge red-proyecto
docker network ls
docker network inspect red-proyecto
```

Ejecuta Nginx en esa red:

```bash
docker run -d \
  --name nginx-red \
  --restart unless-stopped \
  --network red-proyecto \
  -p 8082:80 \
  -v /proyecto/web:/usr/share/nginx/html:ro \
  nginx:latest
```

Verifica:

```bash
curl -I http://localhost:8082
docker network inspect red-proyecto --format '{{range .Containers}}{{.Name}} -> {{.IPv4Address}}{{println}}{{end}}'
docker inspect -f '{{json .NetworkSettings.Networks}}' nginx-red
```

Debes ver `nginx-red` dentro de `red-proyecto` con una IP del rango de la red.

**Por qué una red propia:** Docker crea un DNS interno. Los contenedores de una red definida por el usuario se resuelven por **nombre** (por ejemplo, `nginx-red`), cosa que no ocurre en la red `bridge` por defecto. Además aísla el tráfico del resto de contenedores.

## 7.2 Volumen persistente

```bash
docker volume create volumen-web
docker volume ls
```

Ejecuta Nginx montando el volumen:

```bash
docker run -d \
  --name nginx-volumen \
  --restart unless-stopped \
  --network red-proyecto \
  -p 8083:80 \
  -v volumen-web:/usr/share/nginx/html \
  nginx:latest
```

Copia el sitio dentro del volumen:

```bash
docker cp /proyecto/web/index.html nginx-volumen:/usr/share/nginx/html/index.html
```

Verifica:

```bash
docker exec nginx-volumen ls -l /usr/share/nginx/html
curl -I http://localhost:8083
docker volume inspect volumen-web
```

**Prueba de persistencia** (la parte importante):

```bash
docker rm -f nginx-volumen

docker run -d \
  --name nginx-volumen \
  --restart unless-stopped \
  --network red-proyecto \
  -p 8083:80 \
  -v volumen-web:/usr/share/nginx/html \
  nginx:latest

curl -s http://localhost:8083 | grep -i "proyecto"
```

El contenido sigue ahí porque el volumen es independiente del ciclo de vida del contenedor. En cambio, si hubieras usado un bind mount a una carpeta temporal o hubieras borrado los datos, se habría perdido.

| Concepto | Bind mount | Volumen nombrado |
|---|---|---|
| Dónde vive | Ruta del host que tú eliges | `/var/lib/docker/volumes/...` |
| Gestión | Manual | Docker |
| Portabilidad | Depende del host | Mejor |
| Uso típico | Desarrollo, configuración | Datos persistentes |
| Ejemplo del proyecto | 8080 y 8082 | 8083 |

> **Evidencia F07_01:** `docker network inspect red-proyecto` con `nginx-red`.
> **Evidencia F07_02:** navegador en `http://localhost:8082`.
> **Evidencia F07_03:** `docker volume inspect volumen-web` y `ls` dentro del contenedor.
> **Evidencia F07_04:** navegador en `http://localhost:8083` y prueba de persistencia.

**Snapshot `07-red-volumen`:** ejecútalo en el host.

```bash
# [HOST]
VBoxManage snapshot "Debian 13" take "07-red-volumen"
```

---

# Fase 8 — Pruebas y verificación final

## 8.1 Conectividad con Alpine

Ejecuta un contenedor Alpine en la misma red y haz ping al Nginx:

```bash
docker run --rm -it --network red-proyecto alpine ping -c 4 nginx-red
```

Salida esperada:

```text
PING nginx-red (172.18.0.2): 56 data bytes
64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.085 ms
...
4 packets transmitted, 4 packets received, 0% packet loss
```

Si falla el nombre:

```bash
docker run --rm -it --network red-proyecto alpine sh -c 'nslookup nginx-red; ping -c 2 nginx-red'
```

**Por qué funciona:** el DNS interno de Docker resuelve `nginx-red` a su IP dentro de `red-proyecto`; Alpine incluye `ping` de BusyBox y el contenedor tiene la capacidad `NET_RAW` por defecto.

## 8.2 Verificación integral

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'

sudo ss -tlnp | grep -E ':808[0-3]'

for p in 8080 8081 8082 8083; do
  printf "Puerto %s -> HTTP %s\n" "$p" "$(curl -s -o /dev/null -w '%{http_code}' http://localhost:$p)"
done

sudo tail -n 30 /var/log/proyecto/reporte_sistema.log

cd /proyecto && git status --short && git log --oneline -5
```

Los cuatro puertos deben devolver `200`. El log debe mostrar entradas recientes. `git status` debe estar limpio (o solo con archivos nuevos que estés por commitear).

### Cierre del repositorio

Antes de exportar la VM, registra los cambios de las fases 5 a 8:

```bash
cd /proyecto
git switch main
git pull --ff-only
git add .
git commit -m "Fases 5-8: Nginx, Dockerfile, red, volumen y pruebas"
git push
git status
```

Si trabajaron con ramas y Pull Requests, primero fusiona todos los PR y vuelve a
`main` con `git pull --ff-only`; no hagas el commit final sobre una rama de un
integrante. Si algún integrante aún no tiene commits, es el momento de asignarle
una rama y que suba el suyo.

### Script de verificación automática (opcional, suma puntos)

Copia la plantilla `verificar_proyecto.sh` a la VM y ejecútala:

```bash
scp -P 2222 <RUTA_DEL_KIT>/plantillas/verificar_proyecto.sh enoc@127.0.0.1:/tmp/
sudo mv /tmp/verificar_proyecto.sh /proyecto/scripts/
sudo chown adminsys:adminsys /proyecto/scripts/verificar_proyecto.sh
sudo chmod 755 /proyecto/scripts/verificar_proyecto.sh
/proyecto/scripts/verificar_proyecto.sh
```

Reemplaza `<RUTA_DEL_KIT>` por la carpeta donde están estos documentos. Si usas
esta copia revisada, será
`/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135`.

El script revisa hostname, usuarios, grupos, setgid, cron, Docker, los cuatro contenedores, los cuatro puertos, la red, el volumen y Git. Es una excelente evidencia para la fase 8.2.

### Prueba de reinicio (muy recomendada antes de la defensa)

```bash
sudo reboot
```

Espera a que arranque, vuelve a entrar por SSH y comprueba:

```bash
docker ps
curl -I http://localhost:8080
curl -I http://localhost:8081
curl -I http://localhost:8082
curl -I http://localhost:8083
systemctl is-active docker cron
```

Los contenedores deben volver gracias a `--restart unless-stopped` y a que Docker está habilitado. Si no vuelven, revisa `docker inspect` y la política de reinicio.

> **Evidencia F08_01:** `ping` con 4 paquetes y 0 % de pérdida.
> **Evidencia F08_02:** `docker ps` con los 4 contenedores y los 4 puertos en 200.
> **Evidencia F08_03:** `tail` del log de cron.
> **Evidencia F08_04:** `git status` y `git log`.
> **Evidencia F08_05:** prueba de reinicio (opcional pero muy convincente).

**Snapshot final `08-final`:** ejecútalo en el host y luego exporta la OVA según
`02_VM_EXPORTAR_IMPORTAR.md`.

```bash
# [HOST]
VBoxManage snapshot "Debian 13" take "08-final"
```

---

# Apéndice A — Solución de problemas

| Error | Causa | Solución |
|---|---|---|
| `The character device /dev/vboxdrv does not exist` | VirtualBox no puede cargar su módulo en el host | `sudo /sbin/vboxconfig`; `sudo modprobe vboxdrv`; `sudo usermod -aG vboxusers "$USER"`; reinicia; revisa Secure Boot |
| `sudo: command not found` | `sudo` no instalado | Como root: `apt install sudo && usermod -aG sudo enoc` |
| `hostname: Name or service not known` | Falta la entrada en `/etc/hosts` | Agrega `127.0.1.1 servidor-grupo7` |
| `usermod: group 'soporte' does not exist` | No creaste el grupo | `sudo groupadd soporte` |
| `Permission denied` al escribir en `/proyecto/datos` | Usuario fuera del grupo o sin setgid | `id usuario`; `ls -ld`; vuelve a iniciar sesión |
| `docker: permission denied ... docker.sock` | Sesión sin el grupo docker | Cierra sesión y entra de nuevo; `newgrp docker` |
| `Cannot connect to the Docker daemon` | Servicio detenido | `sudo systemctl start docker`; `systemctl status docker` |
| `port is already allocated` | Puerto ocupado | `sudo ss -tlnp \| grep PUERTO`; cambia el mapeo |
| `403 Forbidden` en Nginx | Permisos o falta `index.html` | `ls -l /proyecto/web`; `chmod 644 index.html` |
| `404 Not Found` | Mount incorrecto | `docker exec ... ls -l /usr/share/nginx/html` |
| `ping: bad address 'nginx-red'` | Contenedor fuera de la red | `docker network connect red-proyecto nginx-red` o revisa `--network` |
| Cron no ejecuta | Servicio detenido o script sin `+x` | `systemctl status cron`; `chmod +x`; revisa `journalctl -u cron` |
| `fatal: remote origin already exists` | Remoto ya configurado | `git remote set-url origin URL` |
| `Permission denied (publickey)` | Clave SSH no registrada | `ssh -T git@github.com`; agrega la pública en GitHub |
| La VM no abre los puertos en el host | Reenvío NAT | Revisa VirtualBox → Red → Reenvío de puertos |

---

# Apéndice B — Comandos de limpieza (usar con cuidado)

```bash
# Ver qué se puede liberar
docker system df

# Detener y eliminar un contenedor concreto
docker rm -f nginx-basico

# Eliminar una imagen concreta
docker rmi servidor-grupo7

# Eliminar la red y el volumen (solo si vas a repetir la fase)
docker network rm red-proyecto
docker volume rm volumen-web

# Limpieza general (NO ejecutar antes de la defensa)
# docker system prune -a
```

> No ejecutes `docker system prune -a` ni `docker volume prune` antes de la entrega: eliminarías imágenes, redes y volúmenes que necesitas demostrar.

---

# Apéndice C — Mapa de capturas para el informe

| Código | Fase | Qué debe mostrar |
|---|---|---|
| F01_01 | 1.1 | `hostnamectl` y `getent hosts` |
| F01_02 | 1.2 | `id` de los tres usuarios |
| F01_03 | 1.2 | `getent group` y `sudo whoami` |
| F01_04 | 1.3 | `ls -ld /proyecto/*` con la `s` |
| F01_05 | 1.3 | Archivos de prueba con grupo heredado |
| F02_01 | 2.1 | Salida del script |
| F02_02 | 2.2 | `/etc/cron.d/proyecto` y estado de cron |
| F02_03 | 2.2 | Log con marcas de tiempo |
| F03_01 | 3.1 | `git log --graph` |
| F03_02 | 3.2 | `git remote -v` y `push` |
| F03_03 | 3.2 | Repositorio en GitHub |
| F03_04 | 3.3 | Commits de los cuatro integrantes |
| F04_01 | 4.1 | `docker version` / `docker info` |
| F04_02 | 4.2 | `getent group docker` e `id` |
| F04_03 | 4.3 | `hello-world` y `docker ps -a` |
| F05_01 | 5.2 | `docker ps` con `nginx-basico` |
| F05_02 | 5.3 | Navegador en 8080 |
| F05_03 | 5.3 | `docker logs` sin errores |
| F06_01 | 6.1 | Dockerfile |
| F06_02 | 6.2 | `docker build` e `images` |
| F06_03 | 6.3 | Navegador en 8081 |
| F06_04 | 6.4 | Comparación 8080/8081 |
| F07_01 | 7.1 | `network inspect` |
| F07_02 | 7.1 | Navegador en 8082 |
| F07_03 | 7.2 | `volume inspect` |
| F07_04 | 7.2 | Navegador en 8083 y persistencia |
| F08_01 | 8.1 | `ping` con 0 % de pérdida |
| F08_02 | 8.2 | Los 4 puertos en 200 y `docker ps` |
| F08_03 | 8.2 | Log de cron y `git status` |

---

# Apéndice D — Resumen de comandos por fase

```text
Fase 1: hostnamectl, adduser, groupadd, usermod, mkdir, chown, chgrp, chmod 2775
Fase 2: reporte_sistema.sh, chmod +x, /etc/cron.d/proyecto, systemctl cron
Fase 3: git init, git add, git commit, git remote, git push
Fase 4: docker-ce, systemctl docker, usermod -aG docker, docker run hello-world
Fase 5: index.html, docker run -d -p 8080:80 -v /proyecto/web:... nginx
Fase 6: Dockerfile, docker build -t servidor-grupo7, docker run -p 8081:80
Fase 7: docker network create red-proyecto, docker volume create volumen-web
Fase 8: alpine ping, curl 8080-8083, tail log, git status
```

---

**Fin de la guía.** Continúa con `03_INFORME_Y_EVIDENCIAS.md` para convertir todo esto en el PDF y con `04_PRESENTACION_DEFENSA.md` para la exposición.
