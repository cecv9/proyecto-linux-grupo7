# Guía para ejecutar la máquina virtual del proyecto

## 1. Identificación de la VM

| Dato | Valor |
|---|---|
| Nombre de la VM en VirtualBox | `Debian 13` |
| Hostname interno | `servidor-grupo7` |
| Usuario principal | `adminsys` |
| Acceso SSH | `ssh -p 2222 adminsys@127.0.0.1` |
| Puertos web | `8080`, `8081`, `8082`, `8083` |

> En el informe, los snapshots aparecen como `Debian 13`. Si al importar la VM
> queda con otro nombre, usa ese nombre en todos los comandos. Puedes verlo con
> `VBoxManage list vms`.

## 2. Requisitos en el host

- VirtualBox 7.2 o compatible.
- La VM del proyecto en formato `.ova`, o la carpeta con `.vbox` y `.vdi`.
- 4 GB de RAM libres como mínimo.
- Puertos `2222` y `8080` a `8083` libres en el host.

## 3. Importar la VM

### Opción A: tienes un archivo `.ova`

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" import "C:\ruta\servidor-grupo7.ova"
```

También puedes usar la interfaz gráfica: **Archivo → Importar servicio virtualizado**.

### Opción B: tienes la carpeta con `.vbox` y `.vdi`

1. Copia la carpeta completa a:
   `C:\Users\Usuario\VirtualBox VMs\Debian 13\`
2. Registra la VM:

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" registervm "C:\Users\Usuario\VirtualBox VMs\Debian 13\Debian 13.vbox"
```

3. Comprueba que aparece:

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list vms
```

## 4. Configurar los puertos (NAT)

La VM debe estar apagada para cambiar la configuración. Ejecuta en PowerShell:

```powershell
$VBox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$VM = "Debian 13"

& $VBox modifyvm $VM --natpf1 "ssh,tcp,,2222,,22"
& $VBox modifyvm $VM --natpf1 "web8080,tcp,,8080,,8080"
& $VBox modifyvm $VM --natpf1 "web8081,tcp,,8081,,8081"
& $VBox modifyvm $VM --natpf1 "web8082,tcp,,8082,,8082"
& $VBox modifyvm $VM --natpf1 "web8083,tcp,,8083,,8083"
```

Si ya existían reglas con esos nombres, bórralas primero o usa otros nombres:

```powershell
& $VBox modifyvm $VM --natpf1 delete "ssh"
```

También se puede hacer desde la interfaz: **Configuración → Red → Adaptador 1 →
Avanzado → Reenvío de puertos**.

## 5. Encender la VM

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "Debian 13"
```

O abre VirtualBox y pulsa **Iniciar**.

## 6. Entrar por SSH

```powershell
ssh -p 2222 adminsys@127.0.0.1
```

Si es la primera conexión, acepta la huella. Usa la contraseña que definieron
en el laboratorio. No escribas contraseñas en el README ni en el informe.

## 7. Comprobar el proyecto dentro de la VM

```bash
hostname
cd /proyecto
git pull
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'

for p in 8080 8081 8082 8083; do
  curl -s -o /dev/null -w "$p -> %{http_code}\n" "http://localhost:$p"
done

/proyecto/scripts/verificar_proyecto.sh; echo "Código de salida: $?"
```

Debes ver:

- `servidor-grupo7`
- Los 4 contenedores activos.
- `8080 -> 200`, `8081 -> 200`, `8082 -> 200`, `8083 -> 200`.
- `RESULTADO: todas las verificaciones pasaron` y código `0`.

## 8. Organizar las capturas dentro de la VM

El repositorio ya trae las carpetas por fase. Si la VM tiene capturas sueltas
o carpetas antiguas `F04` a `F08`, ejecuta:

```bash
cd /proyecto
chmod +x scripts/organizar_capturas_vm.sh
./scripts/organizar_capturas_vm.sh
```

El script crea un respaldo en `/proyecto/capturas_backup_FECHA` y mueve las
evidencias a:

```text
capturas/
├── INDICE.md
├── fase-00-preparacion/
├── fase-01-administracion-basica/
├── fase-02-automatizacion-monitoreo/
├── fase-03-control-versiones/
├── fase-04-docker/
├── fase-05-nginx-basico/
├── fase-06-imagen-personalizada/
├── fase-07-redes-volumenes/
└── fase-08-pruebas-verificacion/
```

## 9. Si algo no arranca

### Docker no está activo

```bash
sudo systemctl enable --now docker
sudo systemctl status docker --no-pager
```

### Un contenedor está detenido

```bash
docker ps -a
docker start nginx-basico nginx-personalizado nginx-red nginx-volumen
```

### No responde el puerto desde el host

1. Comprueba dentro de la VM:
   ```bash
   curl -I http://localhost:8080
   ```
2. Si dentro funciona y fuera no, revisa el reenvío de puertos en VirtualBox.
3. Comprueba que el puerto no esté ocupado en Windows:
   ```powershell
   netstat -ano | findstr :8080
   ```

### Error de permisos con Docker

```bash
id
newgrp docker
docker ps
```

Si sigue fallando, cierra la sesión SSH y vuelve a entrar.

### La VM no aparece

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list vms
```

Usa el nombre exacto que devuelva ese comando.

## 10. Apagar la VM correctamente

```bash
sudo shutdown -h now
```

O desde VirtualBox: **Máquina → Atrás → Apagar la máquina**.
