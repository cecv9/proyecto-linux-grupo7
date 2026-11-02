# Guía para importar y demostrar la OVA del Grupo 7

Esta guía es para los compañeros que descarguen la VM final del proyecto
**Introducción al Software Libre — Grupo 7**. La OVA ya contiene Debian, Docker,
cron, Git, Nginx, la imagen propia, la red y el volumen. No deben volver a
instalar ni configurar el proyecto desde cero.

Archivos que se comparten:

```text
proyecto-isl135-grupo7.ova
proyecto-isl135-grupo7.ova.sha256
```

La OVA pesa aproximadamente **4.2 GB**. El archivo `.sha256` sirve para
comprobar que la descarga terminó completa y que el archivo no está dañado.
No hace falta un archivo `.mf` separado: el manifiesto está dentro de la OVA.

> Las contraseñas de las cuentas de la VM se comparten por un canal privado.
> No deben escribirse en GitHub ni en esta guía.

## 1. Requisitos en la computadora

Antes de importar, comprobar:

- VirtualBox 7.2 o una versión compatible más reciente.
- Virtualización por hardware habilitada en el equipo.
- Espacio libre suficiente: se recomienda al menos 15 GB para importar y
  arrancar; 25 GB es más cómodo.
- Preferiblemente 16 GB de RAM en el equipo anfitrión para conservar los
  8192 MB de la VM. En un equipo de 8 o 12 GB conviene reducir la RAM de la VM
  a 4096 MB al importar, cerrar otras aplicaciones pesadas y documentar ese
  cambio.
- Puertos locales libres: `2222`, `8080`, `8081`, `8082` y `8083`.
- Build de OpenSSH cliente para entrar por terminal. En Windows 10/11 suele
  estar disponible como `ssh`.

No se necesita instalar Docker ni Nginx en la computadora anfitriona.

## 2. Descargar los dos archivos

Colocar ambos archivos en la misma carpeta. Ejemplo:

```text
Descargas/
├── proyecto-isl135-grupo7.ova
└── proyecto-isl135-grupo7.ova.sha256
```

No cambiar el nombre de la OVA si todavía se va a comprobar el checksum.

## 3. Explicación del archivo `.sha256`

El archivo contiene una huella digital calculada a partir de todos los bytes de
la OVA:

```text
249cae68a705ce772a249dd6d78aa3eaa86219b67b4409216c0928798067dcd4  proyecto-isl135-grupo7.ova
```

Si la descarga se interrumpe, se corrompe o el proveedor entrega una versión
distinta, el valor calculado no coincidirá. Un error aquí significa que la OVA
no debe importarse; hay que descargarla nuevamente.

### Linux

Abrir una terminal en la carpeta donde están los dos archivos y ejecutar:

```bash
sha256sum -c proyecto-isl135-grupo7.ova.sha256
```

Resultado correcto:

```text
proyecto-isl135-grupo7.ova: OK
```

### Windows PowerShell

Situarse en la carpeta de descarga y ejecutar:

```powershell
(Get-FileHash .\proyecto-isl135-grupo7.ova -Algorithm SHA256).Hash.ToLower()
```

Debe imprimir exactamente:

```text
249cae68a705ce772a249dd6d78aa3eaa86219b67b4409216c0928798067dcd4
```

### macOS

En una terminal, dentro de la carpeta de descarga:

```bash
shasum -a 256 -c proyecto-isl135-grupo7.ova.sha256
```

Si aparece `OK`, la OVA está íntegra.

## 4. Comprobar que los puertos estén libres

La VM usa NAT con estos reenvíos:

| Uso | Puerto en la computadora | Puerto en la VM |
|---|---:|---:|
| SSH | `2222` | `22` |
| Sitio con bind mount | `8080` | `8080` |
| Imagen propia | `8081` | `8081` |
| Red personalizada | `8082` | `8082` |
| Volumen persistente | `8083` | `8083` |

En Linux se puede comprobar con:

```bash
ss -tlnp | grep -E ':(2222|8080|8081|8082|8083)\b'
```

No debe mostrar otro servicio escuchando en esos puertos.

En Windows PowerShell:

```powershell
Get-NetTCPConnection -State Listen |
  Where-Object LocalPort -in 2222,8080,8081,8082,8083
```

Si otro programa o una VM anterior ocupa los puertos, hay que apagarlo antes de
arrancar esta VM. No se deben arrancar al mismo tiempo `"Debian 13"` y
`"servidor-grupo7-copia"` o `"servidor-grupo7-demo"`, porque ambas quieren usar
los mismos puertos del host.

## 5. Importar la OVA con la interfaz de VirtualBox

1. Abrir VirtualBox.
2. Entrar en **Archivo → Importar servicio virtualizado**.
3. Seleccionar `proyecto-isl135-grupo7.ova`.
4. Revisar los recursos. La VM original usa 4 vCPU y 8192 MB de RAM.
5. Marcar **Reinicializar la dirección MAC de todas las tarjetas de red**.
6. Poner un nombre único, por ejemplo:

   ```text
   servidor-grupo7-demo
   ```

7. Completar la importación.
8. Abrir **Configuración → Red → Adaptador 1** y comprobar que sea **NAT**.
9. Entrar en **Avanzado → Reenvío de puertos** y confirmar las cinco reglas de
   la tabla anterior.
10. Iniciar la VM.

La importación puede tardar varios minutos porque crea un disco virtual nuevo en
la computadora. No se debe apagar ni interrumpir VirtualBox durante ese proceso.

## 6. Importar por terminal

Antes de la importación real se puede hacer una simulación que no crea la VM:

```bash
VBoxManage import proyecto-isl135-grupo7.ova --dry-run
```

Debe terminar sin errores y describir `Debian_64`, 4 CPU, 8192 MB de RAM, red
NAT y el disco virtual.

### Linux o macOS

Desde la carpeta que contiene la OVA:

```bash
VBoxManage import proyecto-isl135-grupo7.ova --vsys 0 --vmname "servidor-grupo7-demo"
```

Regenerar la MAC:

```bash
VBoxManage modifyvm "servidor-grupo7-demo" --macaddress1 auto
```

Verificar los reenvíos:

```bash
VBoxManage showvminfo "servidor-grupo7-demo" --machinereadable | grep -i Forwarding
```

Arrancar sin ventana gráfica:

```bash
VBoxManage startvm "servidor-grupo7-demo" --type headless
```

### Windows

Si `VBoxManage` no está en el `PATH`, usar la ruta completa:

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" import .\proyecto-isl135-grupo7.ova --vsys 0 --vmname "servidor-grupo7-demo"
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "servidor-grupo7-demo" --macaddress1 auto
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "servidor-grupo7-demo" --type headless
```

## 7. Entrar por SSH

Esperar entre 30 y 60 segundos después de arrancar. Desde otra terminal del
equipo anfitrión:

```bash
ssh -p 2222 adminsys@127.0.0.1
```

Cuando solicite la contraseña, escribirla directamente en la terminal.

Entrar al proyecto:

```bash
cd /proyecto
```

El prompt correcto es:

```text
adminsys@servidor-grupo7:/proyecto$
```

Si sale un aviso de que cambió la clave del host, normalmente ocurre porque en
ese puerto se probó otra VM anterior. En Linux/macOS se elimina el registro
antiguo y se vuelve a conectar:

```bash
ssh-keygen -R "[127.0.0.1]:2222"
ssh -p 2222 adminsys@127.0.0.1
```

Solo hacer esto si el equipo y la OVA son confiables.

## 8. Comprobación inicial

Ejecutar en orden:

```bash
hostname
cat /etc/os-release
systemctl is-active ssh docker cron
```

Resultado esperado:

- `hostname`: `servidor-grupo7`.
- Debian 13.
- Tres líneas `active` para SSH, Docker y cron.

Comprobar los contenedores:

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Deben aparecer:

| Contenedor | Puerto |
|---|---:|
| `nginx-basico` | `8080` |
| `nginx-personalizado` | `8081` |
| `nginx-red` | `8082` |
| `nginx-volumen` | `8083` |

## 9. Pruebas ordenadas de las fases

Las fases 1 a 8 ya están construidas. Estas pruebas sirven para demostrar que la
OVA conservó todos los requisitos. No hay que reinstalar Docker, crear usuarios
ni repetir las configuraciones.

### Fase 1 — Hostname, usuarios, grupos y permisos

```bash
hostname
getent hosts servidor-grupo7
id adminsys
id tecnico
id visitante
getent group soporte web sudo docker
ls -ld /proyecto /proyecto/datos /proyecto/web /proyecto/scripts /proyecto/capturas
```

Resultado esperado:

- Hostname `servidor-grupo7`.
- Existen los tres usuarios.
- `adminsys` está en `sudo` y `docker`.
- `tecnico` está en `soporte` y `docker`.
- `visitante` está en `web`.
- `datos` tiene grupo `soporte` y permiso `drwxrwsr-x`.
- `web` tiene grupo `web` y permiso `drwxrwsr-x`.

Prueba opcional de herencia de grupo:

```bash
sudo -u tecnico touch /proyecto/datos/prueba_importacion_tecnico
sudo -u visitante touch /proyecto/web/prueba_importacion_visitante
stat -c '%U:%G %A %n' /proyecto/datos/prueba_importacion_tecnico /proyecto/web/prueba_importacion_visitante
```

Resultado esperado:

```text
tecnico:soporte ...
visitante:web ...
```

Limpiar únicamente esos dos archivos de prueba:

```bash
sudo rm -f /proyecto/datos/prueba_importacion_tecnico /proyecto/web/prueba_importacion_visitante
```

### Fase 2 — Script de monitoreo y cron

```bash
ls -l /proyecto/scripts/reporte_sistema.sh
/proyecto/scripts/reporte_sistema.sh
cat /etc/cron.d/proyecto
systemctl is-active cron
sudo tail -n 20 /var/log/proyecto/reporte_sistema.log
```

Resultado esperado:

- Script ejecutable.
- Reporte con fecha, hostname, usuarios, disco, RAM y contenedores.
- Una entrada `*/30` que ejecuta `reporte_sistema.sh`.
- Cron `active`.
- Al menos dos bloques de log con fechas separadas aproximadamente 30 minutos.

Después de importar la OVA, el log conserva entradas anteriores. Si el script
muestra un aviso de que el log no cambió en los últimos 35 minutos, esperar la
siguiente ejecución programada de cron.

### Fase 3 — Git y GitHub

```bash
git status --short --branch
git log --oneline --decorate -8
git remote -v
git log --format='%an' | sort -u
```

Resultado esperado:

- Rama `## main...origin/main`, sin archivos pendientes.
- Remoto de GitHub.
- Al menos cuatro autores reales del grupo.
- El commit final del proyecto debe incluir `4f64f47`.

Si el repositorio muestra cambios porque se crearon archivos durante una prueba,
no hacer `git reset --hard`. Revisar con `git status` qué se creó.

### Fase 4 — Docker y hello-world

```bash
docker --version
systemctl is-active docker
docker images
docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
```

Para ejecutar una comprobación adicional de Docker:

```bash
docker run --rm hello-world
```

Resultado esperado: mensaje `Hello from Docker!` y salida `Exited (0)`.

### Fase 5 — Nginx con bind mount en 8080

```bash
docker port nginx-basico
docker inspect -f '{{json .Mounts}}' nginx-basico
curl -I http://localhost:8080
curl -s http://localhost:8080 | grep -i 'Grupo 7'
docker logs --tail 20 nginx-basico
```

Resultado esperado:

- `8080/tcp -> 0.0.0.0:8080`.
- Montaje `/proyecto/web` en modo solo lectura.
- HTTP `200 OK`.
- Texto del Grupo 7.
- Sin errores en los últimos logs.

### Fase 6 — Imagen propia en 8081

```bash
docker images | grep servidor-grupo7
docker inspect -f '{{json .Mounts}}' nginx-personalizado
curl -I http://localhost:8081
curl -s http://localhost:8081 | grep -i 'Grupo 7'
```

Resultado esperado:

- Imagen `servidor-grupo7`.
- `Mounts=[]` o `[]`, porque el sitio está copiado dentro de la imagen.
- HTTP `200 OK`.

Explicación para la defensa:

- `8080` lee el contenido del bind mount en `/proyecto/web`.
- `8081` usa el contenido `COPY` dentro de `servidor-grupo7`.

### Fase 7 — Red personalizada y volumen

```bash
docker network inspect red-proyecto
docker volume inspect volumen-web
docker inspect -f '{{json .Mounts}}' nginx-volumen
curl -I http://localhost:8082
curl -I http://localhost:8083
docker exec nginx-volumen cat /usr/share/nginx/html/index.html | grep -i 'Grupo 7'
```

Resultado esperado:

- Red `red-proyecto` con controlador bridge.
- Volumen `volumen-web`.
- `nginx-red` conectado a la red personalizada y respondiendo en `8082`.
- `nginx-volumen` usando el volumen y respondiendo en `8083`.

### Fase 8 — DNS, puertos, reinicio e integración

Probar la resolución interna de Docker:

```bash
docker run --rm --network red-proyecto alpine ping -c 4 nginx-red
```

Resultado esperado: cuatro respuestas y `0% packet loss`.

Probar los cuatro puertos:

```bash
for p in 8080 8081 8082 8083; do
  printf '%s -> ' "$p"
  curl -s -o /dev/null -w '%{http_code}\n' "http://localhost:$p"
done
```

Resultado esperado:

```text
8080 -> 200
8081 -> 200
8082 -> 200
8083 -> 200
```

Ejecutar el verificador integral incluido en la OVA:

```bash
/proyecto/scripts/verificar_proyecto.sh
```

Resultado esperado:

```text
RESULTADO: todas las verificaciones pasaron.
```

Si aparece un aviso sobre la antigüedad del log de cron, no es un fallo de los
servicios. Esperar la siguiente ejecución programada o revisar nuevamente más
tarde.

## 10. Prueba de reinicio

Esta prueba demuestra que los contenedores vuelven solos. Ejecutar:

```bash
sudo reboot
```

Esperar aproximadamente un minuto y reconectar:

```bash
ssh -p 2222 adminsys@127.0.0.1
cd /proyecto
```

Comprobar:

```bash
systemctl is-active docker cron
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Los cuatro contenedores deben volver a estar activos y conservar los puertos.
Después:

```bash
for p in 8080 8081 8082 8083; do
  printf '%s -> ' "$p"
  curl -s -o /dev/null -w '%{http_code}\n' "http://localhost:$p"
done
```

También responderán `200`. Esta es la prueba más importante para mostrar que la
política de reinicio automático funciona.

## 11. Comprobar desde el navegador del host

Con la VM encendida, abrir:

- <http://localhost:8080>
- <http://localhost:8081>
- <http://localhost:8082>
- <http://localhost:8083>

Las cuatro páginas deben mostrar el sitio del Grupo 7.

## 12. Resultado mínimo para aprobar la importación

Marcar todo antes de afirmar que la OVA funciona:

- [ ] Checksum `OK`.
- [ ] La VM importada arranca.
- [ ] SSH funciona como `adminsys`.
- [ ] Docker y cron están `active`.
- [ ] Los cuatro contenedores están activos.
- [ ] Los cuatro puertos responden `200`.
- [ ] `red-proyecto` y `volumen-web` existen.
- [ ] El ping de Alpine llega a `nginx-red` con 0 % de pérdida.
- [ ] Git está limpio y contiene los cuatro autores.
- [ ] `verificar_proyecto.sh` pasa.
- [ ] Los cuatro sitios responden `200` después de reiniciar.

## 13. Problemas frecuentes

| Síntoma | Revisión |
|---|---|
| El checksum no coincide | Descargar la OVA otra vez; no importar el archivo dañado |
| VirtualBox no importa | Actualizar VirtualBox y comprobar espacio libre |
| `Connection refused` en SSH | Esperar a que termine el arranque y comprobar `2222 → 22` |
| `Permission denied (publickey,password)` | Usar usuario `adminsys` y la contraseña privada correcta |
| Aviso de host key cambiada | `ssh-keygen -R "[127.0.0.1]:2222"` y volver a conectar |
| El puerto ya está ocupado | Apagar otra VM o cambiar los reenvíos NAT |
| `localhost:8080` no abre | Revisar `docker ps`, `curl` interno y el reenvío `8080` |
| Docker pide `sudo` | Cerrar SSH y volver a entrar; comprobar `id adminsys` |
| Cron muestra aviso de antigüedad | Esperar la siguiente ejecución de `*/30` |
| Los snapshots no aparecen | Es normal: las OVA no incluyen snapshots |

## 14. Qué no hacer

- No ejecutar `docker system prune -a`.
- No borrar `/proyecto` ni el volumen `volumen-web`.
- No cambiar los puertos sin actualizar las pruebas y la documentación.
- No arrancar simultáneamente dos copias de esta VM en el mismo host.
- No subir la OVA a GitHub.
- No compartir contraseñas en capturas o repositorios.
- No interpretar un aviso de cron como un fallo si todos los servicios
  responden.

## 15. Cierre de la comprobación

Si el checksum da `OK`, la VM importada arranca, los cuatro puertos responden
`200`, Alpine alcanza `nginx-red` sin pérdida y `verificar_proyecto.sh` termina
con `RESULTADO: todas las verificaciones pasaron`, entonces la OVA está lista
para la demostración del Grupo 7.
