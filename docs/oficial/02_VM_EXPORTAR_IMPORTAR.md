# VM en VirtualBox 7.2: crear, respaldar, exportar e importar

> Esta guía asume un host **Debian 13 con VirtualBox 7.2** (ya instalado) y una VM
> **Debian 13 sin escritorio**. El objetivo es que la VM sea portable: que otro
> integrante la importe y tenga el mismo servidor funcionando.
>
> **Si ya tienes una VM Debian 13 creada**, no crees otra. Revisa que tenga al menos
> 2 vCPU, 3 GB de RAM y 20–25 GB de disco, y sobre todo que el adaptador NAT tenga
> los reenvíos de la sección 1. Si cumple, salta a la sección 2.5.

> **Estado detectado en este equipo (25/10/2026):** existe una VM llamada
> `Debian 13`, apagada, con 4 CPU, 8 GB de RAM, disco VDI de 64 GB y adaptador NAT.
> **No tiene reenvíos de puertos configurados.** El OVA `Debian13.ova` existente
> tampoco los contiene, así que debe corregirse la VM y volver a exportar.

---

## 1. Esquema de red

```
Host Debian 13
  └── VirtualBox
        └── VM «servidor-grupo1» (Debian 13)
              Red: NAT
              Reenvío: 2222→22, 8080→8080, 8081→8081, 8082→8082, 8083→8083
```

- Desde el host: `ssh -p 2222 enoc@127.0.0.1`
- Desde el navegador del host: `http://localhost:8080`, `:8081`, `:8082`, `:8083`
- Desde dentro de la VM: `http://localhost:8080`, etc.

La ventaja de NAT + reenvío es que **no depende de la red del lugar** y las reglas se guardan en la configuración de la VM (viajan en la OVA).

### 1.1 Verificar los reenvíos de la VM existente

En el **host**, con la VM apagada:

```bash
VM="Debian 13"                 # cambia por el nombre exacto de tu VM
VBoxManage showvminfo "$VM" --machinereadable | grep -i Forwarding
```

La salida debe incluir las cinco reglas. Si no aparece nada, créalas:

```bash
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

> El nombre `Debian 13` es solo el nombre de la máquina en VirtualBox. El
> **hostname del sistema** se configura dentro de la VM en la fase 1 y será
> `servidor-grupo1`.

---

## 2. Crear la VM

### 2.1 Descargar la ISO

Descarga `debian-13.x.x-amd64-netinst.iso` desde <https://www.debian.org/download> y verifica su SHA256:

```bash
sha256sum debian-13.*-amd64-netinst.iso
```

Compáralo con el valor publicado en la página de Debian.

### 2.2 Crear la máquina (interfaz gráfica)

1. Abre **VirtualBox → Nueva**.
2. Nombre: `servidor-grupo1`. Tipo: **Linux**. Versión: **Debian (64-bit)**.
3. RAM: **3072 MB mínimo** (4096 MB recomendado). CPU: **2 mínimo**.
4. Disco: **25 GB mínimo**, tipo VDI, asignación dinámica.
5. **Configuración → Red → Adaptador 1: NAT**.
6. **Avanzado → Reenvío de puertos**:

   | Nombre | Protocolo | Puerto host | Puerto invitado |
   |---|---|---|---|
   | ssh | TCP | 2222 | 22 |
   | web8080 | TCP | 8080 | 8080 |
   | web8081 | TCP | 8081 | 8081 |
   | web8082 | TCP | 8082 | 8082 |
   | web8083 | TCP | 8083 | 8083 |

7. **Sistema → Placa base:** desactiva el disquete. **Procesador:** habilita PAE/NX si aparece.
8. Inicia la VM y selecciona la ISO.

### 2.3 Crear la máquina por línea de comandos (opcional, reproducible)

```bash
VM="servidor-grupo1"
VBoxManage createvm --name "$VM" --ostype Debian_64 --register
VBoxManage modifyvm "$VM" --memory 3072 --cpus 2 --vram 16 --graphicscontroller vmsvga
VBoxManage modifyvm "$VM" --nic1 nat
VBoxManage modifyvm "$VM" --natpf1 "ssh,tcp,,2222,,22"
VBoxManage modifyvm "$VM" --natpf1 "web8080,tcp,,8080,,8080"
VBoxManage modifyvm "$VM" --natpf1 "web8081,tcp,,8081,,8081"
VBoxManage modifyvm "$VM" --natpf1 "web8082,tcp,,8082,,8082"
VBoxManage modifyvm "$VM" --natpf1 "web8083,tcp,,8083,,8083"
mkdir -p "$HOME/VirtualBox VMs/$VM"
VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$VM/$VM.vdi" --size 25600
VBoxManage storagectl "$VM" --name "SATA" --add sata --controller IntelAhci
VBoxManage storageattach "$VM" --storagectl "SATA" --port 0 --device 0 --type hdd \
  --medium "$HOME/VirtualBox VMs/$VM/$VM.vdi"
VBoxManage storagectl "$VM" --name "IDE" --add ide
VBoxManage storageattach "$VM" --storagectl "IDE" --port 0 --device 0 --type dvddrive \
  --medium "$HOME/Descargas/isos/debian-13.7.0-amd64-netinst.iso"
VBoxManage startvm "$VM"
```

> Ajusta la ruta y el nombre exacto de la ISO. En este equipo la ISO detectada es
> `/home/enoc/Descargas/isos/debian-13.7.0-amd64-netinst.iso`. Si la carpeta tiene
> espacios, usa comillas.

### 2.4 Instalar Debian 13

1. Idioma, ubicación y teclado (puedes elegir español).
2. Red: DHCP automático.
3. **Hostname:** `servidor-grupo1`; dominio: déjalo vacío.
4. Contraseña de root: puedes dejarla vacía para usar `sudo` con tu usuario.
5. Usuario principal: `enoc` (o tu nombre) con contraseña.
6. Particionado: **usar todo el disco** (guía).
7. Selección de software: **desmarca el entorno de escritorio**; marca **servidor SSH** y **utilidades estándar**.
8. Instala GRUB en el disco.
9. Reinicia y expulsa la ISO.

### 2.5 Configuración posterior a la instalación

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y sudo openssh-server curl git ca-certificates gnupg
sudo systemctl enable --now ssh
sudo timedatectl set-timezone America/El_Salvador
hostnamectl
ip -4 addr show
```

Prueba el acceso desde el host:

```bash
ssh -p 2222 enoc@127.0.0.1
```

Prueba el reenvío de puertos (dentro de la VM):

```bash
cd /tmp && python3 -m http.server 8080
```

En el navegador del host abre `http://localhost:8080`; deberías ver el listado del directorio. Detén el servidor con `Ctrl+C`.

### 2.6 Primer snapshot

En el **host**, con la VM apagada o en un estado estable:

```bash
# [HOST]
VBoxManage snapshot "servidor-grupo1" take "00-base-instalada"
```

---

## 3. Snapshots: red de seguridad

Toma un snapshot **antes de cada fase riesgosa**. No sustituyen al repositorio Git, pero permiten volver atrás en segundos.

| Snapshot | Cuándo |
|---|---|
| `00-base-instalada` | Después de instalar Debian y actualizar |
| `01-fase1` | Usuarios, grupos y permisos listos |
| `02-fase2` | Script y cron funcionando |
| `03-git` | Repositorio local y remoto funcionando |
| `04-docker` | Docker instalado y `hello-world` probado |
| `05-nginx` | Sitio en 8080 |
| `06-imagen` | Imagen propia en 8081 |
| `07-red-volumen` | Red y volumen en 8082/8083 |
| `08-final` | Todo verificado, antes de exportar |

Comandos:

```bash
# [HOST]
VBoxManage snapshot "servidor-grupo1" take "05-nginx"
VBoxManage snapshot "servidor-grupo1" list
VBoxManage snapshot "servidor-grupo1" restore "05-nginx"
```

> Los snapshots se guardan en el disco del host y **no** se incluyen en la OVA. Si necesitas conservarlos, exporta la VM en ese estado.

---

## 4. Exportar la VM a OVA

### 4.1 Antes de exportar

1. Verifica que las 8 fases funcionan.
2. Define contraseñas conocidas para todos los usuarios (las necesitarán tus compañeros):

   ```bash
   sudo passwd enoc
   sudo passwd adminsys
   sudo passwd tecnico
   sudo passwd visitante
   ```

3. Anota las contraseñas en un gestor de contraseñas o en un archivo privado **fuera del repositorio**.
4. Limpia un poco el disco (opcional):

   ```bash
   sudo apt clean
   sudo journalctl --vacuum-size=100M
   docker system df
   ```

5. Apaga la VM de forma limpia:

   ```bash
   sudo poweroff
   ```

### 4.2 Exportar

Desde el host:

```bash
# [HOST]
cd "$HOME"
VBoxManage export "servidor-grupo1" \
  --output "proyecto-isl135-grupo1.ova" \
  --manifest
```

Antes de exportar, confirma que la VM tiene las reglas NAT:

```bash
# [HOST]
VBoxManage showvminfo "servidor-grupo1" --machinereadable | grep -i Forwarding
```

Si no aparecen `2222`, `8080`, `8081`, `8082` y `8083`, vuelve a la sección 1.1.
El OVA actual `Debian13.ova` no sirve como entrega final porque fue exportado sin
esas reglas.

Verifica:

```bash
ls -lh proyecto-isl135-grupo1.ova*
sha256sum proyecto-isl135-grupo1.ova | tee proyecto-isl135-grupo1.ova.sha256
tar -tf proyecto-isl135-grupo1.ova | head
```

La OVA es un archivo TAR que contiene el descriptor OVF, el disco VMDK y el manifiesto. Puede tardar varios minutos; **no interrumpas el proceso**.

### 4.3 Compartir

- Google Drive, OneDrive, Mega o un pendrive.
- **No la subas a GitHub:** supera el límite de 100 MB por archivo.
- Comparte también el archivo `.sha256` para que cada integrante verifique la descarga:

  ```bash
  sha256sum -c proyecto-isl135-grupo1.ova.sha256
  ```

---

## 5. Importar la VM en otra computadora

### 5.1 Interfaz gráfica

1. Instala VirtualBox 7.2 o superior.
2. **Archivo → Importar servicio virtualizado**.
3. Selecciona la OVA.
4. En la pantalla de configuración, marca **«Reinicializar la dirección MAC de todas las tarjetas de red»**.
5. Si ya existe una VM con ese nombre, cambia el nombre (por ejemplo, `servidor-grupo1-copia`).
6. Importa y arranca.

### 5.2 Línea de comandos

```bash
VBoxManage import "proyecto-isl135-grupo1.ova" --dry-run
VBoxManage import "proyecto-isl135-grupo1.ova" --vsys 0 --vmname "servidor-grupo1-copia"
VBoxManage modifyvm "servidor-grupo1-copia" --macaddress1 auto
```

Comprueba las reglas NAT:

```bash
VBoxManage showvminfo "servidor-grupo1-copia" --machinereadable | grep -i Forwarding
```

Si algún puerto del host está ocupado, edita el reenvío en **Configuración → Red → Avanzado → Reenvío de puertos** y usa otro puerto (por ejemplo, 18080). En ese caso la URL será `http://localhost:18080`.

### 5.3 Checklist en el primer arranque

```bash
hostname
ip -4 addr show
systemctl status docker --no-pager
systemctl status cron --no-pager
docker ps
curl -I http://localhost:8080
curl -I http://localhost:8081
curl -I http://localhost:8082
curl -I http://localhost:8083
sudo tail -n 20 /var/log/proyecto/reporte_sistema.log
cd /proyecto && git status && git log --oneline -5
```

Y desde el navegador del host: `http://localhost:8080` a `:8083`.

### 5.4 Credenciales y accesos

- Las contraseñas de `enoc`, `adminsys`, `tecnico` y `visitante` deben conocerse antes de exportar.
- **Nunca** subas contraseñas, tokens de GitHub ni claves SSH al repositorio.
- Cada integrante debe generar su propia clave SSH de GitHub; no compartan la privada.
- Si el repositorio es privado, el dueño debe agregar a los demás como colaboradores.

---

## 6. Alternativas a VirtualBox

| Herramienta | Cómo se exporta/importa | Nota |
|---|---|---|
| **KVM/QEMU + virt-manager** | Apagar, copiar el `.qcow2`, `virsh dumpxml` y `virsh define` (ajustar ruta del disco) | Más manual; el reenvío de puertos se hace en la red de libvirt |
| **GNOME Boxes** | Copiar el `.qcow2` y abrirlo con Boxes | No genera OVA |
| **Plan B: reconstrucción** | Ejecutar de nuevo la guía en una VM limpia | Útil si la OVA no importa; demuestra que entiendes el proceso |

Si usas KVM, puedes comprimir el disco antes de compartirlo:

```bash
qemu-img convert -c -O qcow2 disco.qcow2 disco-comprimido.qcow2
```

---

## 7. Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `The character device /dev/vboxdrv does not exist` | Módulo de VirtualBox no cargado o Secure Boot bloqueándolo | `sudo /sbin/vboxconfig`; `sudo modprobe vboxdrv`; `sudo usermod -aG vboxusers "$USER"`; reinicia; si hay Secure Boot, firma el módulo o desactívalo temporalmente |
| La VM no arranca | Virtualización desactivada, Hyper-V o Secure Boot | Activa VT-x/AMD-V en BIOS/UEFI; en Linux verifica `kvm-ok`; revisa los módulos de VirtualBox |
| La VM no tiene internet | Adaptador mal configurado | Adaptador 1 = NAT; `ping 10.0.2.2`; `ping 1.1.1.1`; revisa `/etc/resolv.conf` |
| El host no abre `localhost:8080` | Regla NAT ausente o servicio caído | `VBoxManage showvminfo "$VM" --machinereadable \| grep -i Forwarding`; `curl` dentro de la VM; `docker ps` |
| «Port already in use» al arrancar la VM | Otro servicio usa el puerto | `sudo ss -tlnp \| grep -E '808[0-3]'`; cambia el puerto host |
| Conflicto de MAC en red puente | Copia de la VM en la misma red | Regenera la MAC o usa NAT |
| Hora incorrecta | Zona horaria | `sudo timedatectl set-timezone America/El_Salvador` |
| La OVA no importa | Versión antigua de VirtualBox o archivo incompleto | Actualiza VirtualBox; verifica el SHA256; vuelve a descargar |
| La OVA pesa demasiado | Disco lleno de imágenes y logs | `apt clean`, `journalctl --vacuum-size`, revisa `docker system df` |
| `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED` al conectar por SSH | La VM importada generó otras claves SSH | `ssh-keygen -R "[127.0.0.1]:2222"` y vuelve a conectar |

---

## 8. Entregable de la VM

- `proyecto-isl135-grupo1.ova`
- `proyecto-isl135-grupo1.ova.sha256`
- Nota privada con las contraseñas y la URL del repositorio.
- Snapshot `pre-defensa` (local, no se comparte).
- Prueba de importación realizada en al menos una computadora distinta a la del creador.

> **Regla:** la OVA debe estar apagada, con los 4 contenedores creados y funcionando, cron activo y el repositorio clonado en `/proyecto`.
