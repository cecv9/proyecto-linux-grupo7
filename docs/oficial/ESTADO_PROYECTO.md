# Estado del Proyecto Final ISL135

> **Este archivo es la memoria compartida entre chats.** Actualízalo al terminar
> cada fase. Un chat nuevo no conserva el historial de la conversación anterior,
> pero sí puede leer este archivo y la guía si se le indica al comenzar.

## 1. Datos del proyecto

| Dato | Valor |
|---|---|
| Materia | Introducción al Software Libre — Ciclo II 2026 |
| Fecha de entrega | 03/11/2026 |
| Número de grupo | **7** |
| Hostname objetivo | `servidor-grupo7` |
| Repositorio remoto | `proyecto-linux-grupo7` |
| Imagen Docker | `servidor-grupo7` |
| Guía principal | `/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/01_GUIA_PASO_A_PASO.md` |
| Guía de ejecución F5 | `/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/FASE_5_COMANDOS.md` |
| Guía de ejecución F6 | `/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/FASE_6_COMANDOS.md` |
| Guía de ejecución F7 | `/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/FASE_7_COMANDOS.md` |
| Guía de ejecución F8 | `/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/FASE_8_COMANDOS.md` |
| Guía para compañeros | `/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/GUIA_COMPANEROS_OVA.md` |
| Guía de VM/OVA | `/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/02_VM_EXPORTAR_IMPORTAR.md` |
| Plantillas | `/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/plantillas/` |
| Carpeta original revisada | `/home/enoc/dsh-workspace/proyecto-isl135/` |

> La VM ya está configurada con el grupo 7. Si el docente informa un número
> diferente, no continúes con el repositorio ni con la imagen hasta corregir la
> configuración y este archivo.

## 2. Estado de la VM

| Dato | Valor |
|---|---|
| Nombre en VirtualBox | `Debian 13` |
| Sistema | Debian 13 |
| CPU / RAM / disco | 4 vCPU / 8 GB / 64 GB |
| Estado actual | Original apagada para exportar; copia importada probada el 30/10/2026 |
| Red | NAT |
| Usuario de acceso SSH | `adminsys` (acceso directo verificado en la Fase 5) |
| Reenvíos NAT | **Completados y verificados** (`2222`, `8080`, `8081`, `8082`, `8083`) |
| Prueba SSH | **Exitosa** desde el host con `ssh -p 2222 adminsys@127.0.0.1` |
| OVA final | `/home/enoc/Descargas/proyecto-isl135-grupo7.ova` — 4.2 GB |
| SHA-256 de la OVA | `249cae68a705ce772a249dd6d78aa3eaa86219b67b4409216c0928798067dcd4` |
| Copia de importación | `servidor-grupo7-copia` (`05f3745b-c7c4-4864-bbfa-772bbf72efd7`) |
| OVA preliminar | `/home/enoc/Descargas/Debian13.ova` — **no usar como OVA final** |
| ISO | `/home/enoc/Descargas/isos/debian-13.7.0-amd64-netinst.iso` |

> **Snapshots regularizados el 30/10/2026:** VirtualBox conserva actualmente
> la cadena `00-base-instalada → 03-git → 04-docker →
> 05-nginx-recuperado → pre-recuperacion-2026-10-30 → 06-imagen →
> 07-red-volumen → 08-final`. Los
> registros históricos `01-fase1`, `02-fase2` y el
> primer `05-nginx` ya no existen en la configuración de la VM y no pueden
> reconstruirse con su estado exacto. Para no bloquear la Fase 6 se creó el
> punto consolidado `05-nginx-recuperado`
> (`1260d56c-1a07-4357-aa4f-b052d35953bc`), que representa el estado funcional
> actual antes de comenzar la Fase 6. Después se preservó el estado dañado en
> `pre-recuperacion-2026-10-30` y se comprobó la cadena hasta
> `08-final` (`485510e8-b5a1-4989-a9ed-4f43a26978cc`). El checklist final ya
> tiene su snapshot final; no exige conservar `01-fase1` y `02-fase2`.
>
> No inicies a la vez `"Debian 13"` y `"servidor-grupo7-copia"`: ambas usan los
> mismos puertos NAT del host. La copia puede apagarse con `sudo poweroff`
> cuando termine la prueba de portabilidad.

## 3. Estado de las fases

- [x] Preparación de la VM: reenvíos NAT configurados y prueba de SSH exitosa
- [x] Número de grupo aplicado en la VM: `7`
- [x] Fase 0: entorno base actualizado, verificado y con snapshot
- [x] Fase 1: hostname, usuarios, grupos, directorios y permisos
- [x] Fase 2: `reporte_sistema.sh` y cron cada 30 minutos
- [x] Fase 3: Git local, GitHub, README y commits de los cuatro integrantes
- [x] Fase 4: Docker y `hello-world`
- [x] Fase 5: Nginx en 8080 con bind mount
- [x] Fase 6: Dockerfile e imagen propia en 8081
- [x] Fase 7: red `red-proyecto` y volumen `volumen-web`
- [x] Fase 8: pruebas finales, reinicio y verificación integral
- [x] Exportar OVA, verificar SHA-256 y probar importación local
- [ ] Informe PDF
- [ ] Presentación de 20 minutos

### 3.1 Detalle de la Fase 0

- [x] Corregir permisos administrativos: `debian` agregado al grupo `sudo`
- [x] Verificar `sudo whoami` → `root`
- [x] Ejecutar `sudo apt update` → índices actualizados
- [x] Confirmar que los cinco reenvíos NAT siguen presentes
- [x] Ejecutar `sudo apt full-upgrade -y`; no hubo paquetes pendientes
- [x] Instalar herramientas base: `curl`, `git`, `vim` y dependencias
- [x] Ejecutar `timedatectl set-timezone America/El_Salvador`
- [x] Verificar zona horaria `America/El_Salvador (CST, -0600)` y NTP activo
- [x] Verificar reinicio: `/var/run/reboot-required` no existe; no reiniciar
- [x] Verificar versión de Debian: `13.7`
- [x] Verificar hostname: `servidor-grupo7`
- [x] Verificar red NAT: `enp0s3` con IPv4 `10.0.2.15/24`
- [x] Verificar servicio SSH: `active`
- [x] Revisar paquetes con `dpkg --audit`: sin errores ni salida
- [x] Tomar las capturas preliminares `F00_01` y `F00_02`
- [x] Tomar la captura `F00_03_herramientas.png`
- [x] Tomar la captura final `F00_04_entorno_base.png`
- [x] Tomar la captura `F00_05_snapshot.png`
- [x] Crear y verificar el snapshot `00-base-instalada`

### 3.2 Detalle de la Fase 1

- [x] Configurar el hostname `servidor-grupo7` con `hostnamectl`
- [x] Configurar y verificar la resolución local en `/etc/hosts`
- [x] Crear los usuarios `adminsys`, `tecnico` y `visitante`
- [x] Crear los grupos `soporte` y `web`
- [x] Agregar `adminsys` al grupo `sudo`
- [x] Agregar `tecnico` al grupo `soporte`
- [x] Agregar `visitante` al grupo `web`
- [x] Verificar que `adminsys` puede ejecutar `sudo whoami` con salida `root`
- [x] Crear `/proyecto/{datos,web,scripts,capturas}`
- [x] Asignar `adminsys:adminsys` como propietario de `/proyecto`
- [x] Asignar el grupo `soporte` a `/proyecto/datos`
- [x] Asignar el grupo `web` a `/proyecto/web`
- [x] Aplicar permisos `2775` con setgid a `datos` y `web`
- [x] Aplicar permisos `775` a `scripts` y `capturas`
- [x] Comprobar la herencia de grupo con `tecnico` y `visitante`
- [x] Limpiar los archivos temporales de la prueba de herencia
- [x] Guardar las capturas `F01_01` a `F01_05` en `/proyecto/capturas/`
- [x] Copiar las evidencias `F00` a `/proyecto/capturas/`
- [x] Crear y verificar el snapshot `01-fase1`

### 3.3 Detalle de la Fase 2

- [x] Crear `/proyecto/scripts/reporte_sistema.sh` como usuario `adminsys`
- [x] Validar la sintaxis con `bash -n` y aplicar permisos `755`
- [x] Verificar la salida con fecha, hostname, usuarios, disco, RAM y Docker
- [x] Confirmar `Hostname: servidor-grupo7`
- [x] Guardar la salida del reporte como evidencia de texto
- [x] Verificar que `cron` esté instalado, habilitado y activo
- [x] Crear `/var/log/proyecto` y el log con permisos `root:adminsys`
- [x] Crear `/etc/cron.d/proyecto` con programación `*/30`
- [x] Probar temporalmente la ejecución de cron y restaurar `*/30`
- [x] Confirmar ejecuciones reales a las `22:00:01` y `22:30:01`, separadas 30 min
- [x] Tomar las capturas `F02_01` a `F02_04`
- [x] Copiar las cuatro capturas a `/proyecto/capturas/` y verificar `adminsys:adminsys 644`
- [x] Crear y verificar el snapshot `02-fase2`

### 3.4 Detalle de la Fase 3

- [x] Inicializar `/proyecto` como repositorio Git en la rama `main`
- [x] Configurar la identidad local de Carlos Enoc Calzada Vargas
- [x] Crear `.gitignore` y los archivos `.gitkeep` de `datos`, `web` y `capturas`
- [x] Preparar y revisar el primer commit de la estructura
- [x] Crear el primer commit `3a8fb9d` con 26 archivos
- [x] Crear en GitHub el repositorio público `cecv9/proyecto-linux-grupo7`
- [x] Generar la clave SSH de `adminsys` y registrarla en la cuenta `cecv9`
- [x] Verificar la autenticación SSH con GitHub
- [x] Configurar `origin` y subir `main`
- [x] Crear el README después del primer `push` en el commit `4954ca3`
- [x] Corregir el salto de línea final y validar el README con SHA-256
- [x] Agregar a Azucena, Ronie y Daniel como colaboradores
- [x] Fusionar los Pull Requests `#1` a `#5`
- [x] Confirmar aportes de los cuatro integrantes en GitHub
- [x] Completar la fila del integrante 4 en el README con el commit `072b553`
- [x] Copiar y versionar las evidencias F03 dentro de `/proyecto/capturas/`
- [x] Publicar las evidencias con los commits `53cf2f1`, `ee64f86` y `618c4df`
- [x] Confirmar el estado limpio `main...origin/main`
- [x] Crear y verificar el snapshot `03-git`

### 3.5 Detalle de la Fase 4

- [x] Prevalidar usuario `adminsys`, hostname, Debian 13, `trixie`, `amd64`,
  Git y conectividad con el repositorio oficial
- [x] Corregir la comprobación de conectividad a
  `dists/trixie/Release`; APT usa `trixie` como suite y `stable` como componente
- [x] Instalar `ca-certificates` y `curl`; ambos ya estaban actualizados
- [x] Descargar la clave oficial a `/etc/apt/keyrings/docker.asc`
- [x] Crear `/etc/apt/sources.list.d/docker.list` con la fuente oficial
- [x] Validar la firma del repositorio con `apt update`
- [x] Instalar `docker-ce`, `docker-ce-cli`, `containerd.io`,
  `docker-buildx-plugin` y `docker-compose-plugin`
- [x] Habilitar e iniciar `docker.service`; `systemctl is-active docker` →
  `active`
- [x] Verificar Docker Engine `29.9.2`, Buildx `0.38.1` y Compose `5.6.1`
- [x] Agregar `adminsys` y `tecnico` al grupo `docker`; GID `989`
- [x] Aplicar el grupo con `newgrp docker` y comprobar `docker ps` sin `sudo`
  para ambas cuentas
- [x] Ejecutar `hello-world`; mensaje `Hello from Docker!`
- [x] Verificar el contenedor con estado `Exited (0)` y la imagen
  `hello-world:latest`
- [x] Guardar y versionar 45 evidencias dentro de
  `/proyecto/capturas/F04/`
- [x] Crear y publicar el commit `1e582b6`
- [x] Transferir y versionar la evidencia final del snapshot con el commit
  `11a1661`
- [x] Confirmar `main...origin/main` limpio y sincronizado
- [x] Crear y verificar el snapshot `04-docker`

### 3.6 Detalle de la Fase 5

- [x] Prevalidar usuario `adminsys`, hostname, grupo `docker`, servicio Docker,
  Git limpio y puerto `8080` libre
- [x] Crear `/proyecto/web/index.html` con el sitio del Grupo 7
- [x] Ajustar permisos `664` y verificar propietario `adminsys`, grupo `web`
- [x] Crear `favicon.svg` y corregir el `404` de `favicon.ico`
- [x] Ejecutar `nginx-basico` con reinicio `unless-stopped`, puerto
  `8080:80` y bind mount `/proyecto/web:/usr/share/nginx/html:ro`
- [x] Verificar contenedor `Up`, publicación `0.0.0.0:8080->80/tcp` y política
  `RestartPolicy=unless-stopped`
- [x] Verificar `curl -I` con `HTTP/1.1 200 OK`
- [x] Verificar que Nginx sirve el texto `Grupo 7`
- [x] Verificar el montaje en modo solo lectura con `RW=false`
- [x] Verificar los logs posteriores a la corrección sin `error`, `emerg` ni
  `crit`
- [x] Validar el sitio desde el navegador del host en
  `http://localhost:8080`
- [x] Guardar y copiar 10 evidencias a `/proyecto/capturas/F05/`
- [x] Crear y publicar el commit `428d76f`
- [x] Publicar la evidencia del snapshot en el commit `895e6ab`
- [x] Completar la evidencia del contenedor y publicarla en `4498f58`
- [x] Confirmar `main...origin/main` limpio y sincronizado
- [x] Crear el snapshot `05-nginx` al cerrar la fase
- [x] Detectar que VirtualBox perdió el registro histórico de ese snapshot
- [x] Crear y verificar el punto consolidado `05-nginx-recuperado` con UUID
  `1260d56c-1a07-4357-aa4f-b052d35953bc`

### 3.7 Detalle de la Fase 6

- [x] Prevalidar `adminsys`, hostname, grupo `docker`, servicio Docker, Git y
  puerto `8081` libre
- [x] Confirmar que `nginx-basico` continúa activo y responde `HTTP 200`
  en `8080`
- [x] Crear `/proyecto/Dockerfile` basado en `nginx:latest`
- [x] Incluir etiquetas del Grupo 7, `COPY web/ /usr/share/nginx/html/`,
  `EXPOSE 80` y el comando de Nginx en primer plano
- [x] Crear `/proyecto/.dockerignore` y aplicar permisos `644` a ambos archivos
- [x] Construir la imagen `servidor-grupo7:latest` sin errores
- [x] Verificar la imagen con ID `sha256:98a1541d8205...`
- [x] Crear `nginx-personalizado` con `--restart unless-stopped` y puerto
  `8081:80`
- [x] Verificar estado `Up`, publicación `0.0.0.0:8081->80/tcp` y política
  `unless-stopped`
- [x] Verificar `HTTP/1.1 200 OK` y el texto `Grupo 7` por red y dentro del
  contenedor
- [x] Confirmar `Mounts=[]`, demostrando que el sitio está dentro de la imagen
- [x] Revisar los logs sin errores y validar la página desde el navegador
- [x] Comparar `8080` y `8081`: ambos responden `HTTP 200`; el primero usa bind
  mount y el segundo contenido copiado en la imagen
- [x] Guardar y copiar 11 capturas adicionales a `/proyecto/capturas/F06/`
- [x] Publicar el commit `c5f1848`
- [x] Crear y verificar el snapshot `06-imagen` con UUID
  `c2532f24-b760-4e38-922d-1c8e71b21fbf`
- [x] Publicar la evidencia del snapshot en el commit `c6fdbea`
- [x] Confirmar `main...origin/main` limpio y sincronizado
- [x] Comprobar que `nginx-basico` y `nginx-personalizado` siguen activos y
  responden `HTTP 200`

### 3.8 Detalle de la Fase 7

- [x] Prevalidar `adminsys`, grupo `docker`, Fases 5 y 6, Git limpio y recursos
  de la Fase 7 libres
- [x] Crear `red-proyecto` con controlador `bridge`, alcance `local` y subred
  `172.18.0.0/16`
- [x] Crear `nginx-red` con política `unless-stopped`, puerto `8082:80`, red
  `red-proyecto` y bind mount `/proyecto/web` en modo solo lectura
- [x] Verificar `nginx-red` en `172.18.0.2/16`, respuesta `HTTP 200`, contenido
  del Grupo 7 y logs limpios
- [x] Validar visualmente `http://localhost:8082` en el navegador del host
- [x] Crear el volumen nombrado `volumen-web` con driver `local`
- [x] Crear `nginx-volumen` con política `unless-stopped`, puerto `8083:80`,
  red `red-proyecto` y montaje `volumen-web:/usr/share/nginx/html`
- [x] Verificar `nginx-volumen` en `172.18.0.3/16`, montaje de tipo `volume`,
  contenido del volumen, respuesta `HTTP 200` y logs limpios
- [x] Crear el testigo `persistencia=2026-10-31T03:07:51Z Grupo 7` dentro del
  volumen
- [x] Eliminar y recrear `nginx-volumen` conservando el mismo volumen
- [x] Confirmar que el volumen y el testigo sobrevivieron a la recreación, y
  que `8083` volvió a responder `HTTP 200`
- [x] Validar visualmente `http://localhost:8083` después de recrear el
  contenedor
- [x] Verificar que `red-proyecto` contiene `nginx-red` y `nginx-volumen`
- [x] Confirmar los cuatro contenedores activos y `HTTP 200` en `8080` a `8083`
- [x] Documentar la diferencia entre contenido en imagen, bind mount, volumen
  nombrado, red personalizada y red bridge predeterminada
- [x] Copiar 49 capturas a `/proyecto/capturas/F07/` con permisos `644`
- [x] Publicar las evidencias técnicas en el commit `cfb5da5`
- [x] Crear y verificar el snapshot `07-red-volumen` con UUID
  `1abb2246-6b24-4780-8bf9-f592df9d0fab`
- [x] Publicar las evidencias del snapshot en el commit `32b85e7`
- [x] Confirmar `main...origin/main` limpio y sincronizado

### 3.9 Detalle de la Fase 8

- [x] Ejecutar Alpine dentro de `red-proyecto` y resolver `nginx-red`
- [x] Confirmar IPv4 `172.18.0.2`, 4 paquetes recibidos y `0% packet loss`
- [x] Verificar los cuatro contenedores activos y los puertos `8080` a `8083`
- [x] Confirmar `HTTP 200` en los cuatro sitios
- [x] Revisar el log de cron con ejecuciones reales separadas 30 minutos
- [x] Confirmar `main...origin/main` limpio antes de reiniciar
- [x] Copiar `verificar_proyecto.sh` a `/proyecto/scripts/`
- [x] Aplicar propietario `adminsys:adminsys` y permisos `755`
- [x] Ejecutar el verificador integral; pasó en estado limpio
- [x] Versionar 37 capturas F08 y sus logs en `/proyecto/capturas/F08/`
- [x] Conservar 47 capturas F08 en el respaldo del host
- [x] Publicar el verificador y las primeras evidencias en `209975a`
- [x] Publicar la verificación aprobada en `9956733`
- [x] Reiniciar la VM y reconectar por SSH
- [x] Confirmar Docker y cron `active`; los cuatro contenedores volvieron solos
- [x] Confirmar `HTTP 200` en los cuatro puertos después del reinicio
- [x] Ejecutar el verificador integral posterior al reinicio; todas pasaron
- [x] Publicar las pruebas de reinicio en `4f64f47`
- [x] Confirmar `main...origin/main` limpio y sincronizado
- [x] Crear y verificar el snapshot `08-final`
- [x] Confirmar el UUID `485510e8-b5a1-4989-a9ed-4f43a26978cc`

### 3.10 Detalle de la OVA

- [x] Verificar los cinco reenvíos NAT antes de exportar
- [x] Confirmar espacio libre suficiente y apagar la VM limpiamente
- [x] Exportar a `/home/enoc/Descargas/proyecto-isl135-grupo7.ova`
- [x] Verificar tamaño de `4.2 GB` y contenido `.ovf`, `.nvram`, `.vmdk` y `.mf`
- [x] Generar y validar el SHA-256
- [x] Ejecutar `VBoxManage import --dry-run` sin errores
- [x] Importar como `servidor-grupo7-copia` sin sobrescribir la VM original
- [x] Regenerar la MAC y confirmar los cinco reenvíos NAT
- [x] Arrancar, conectar por SSH y confirmar Docker y cron `active`
- [x] Confirmar los cuatro contenedores y `HTTP 200` dentro de la copia
- [x] Ejecutar `verificar_proyecto.sh` dentro de la copia; todas pasaron
- [x] Confirmar `HTTP 200` en `8080` a `8083` desde el host
- [x] Guardar 21 capturas y el archivo `.sha256` en `evidencias/OVA/`

> La importación se probó como una VM independiente en este mismo host. La
> checklist del docente recomienda o exige repetirla en un segundo equipo
> físico; ese traslado externo sigue siendo una verificación separada.

## 4. Próximo paso

La parte técnica y la OVA están terminadas. Falta:

1. Redactar y revisar el informe PDF con las capturas F01 a F08 y las evidencias
   de exportación/importación.
2. Preparar y ensayar la presentación de 20 minutos.
3. Si el docente exige una PC distinta, probar allí la OVA y guardar la captura.
4. Pasar el checklist de entrega y compartir la OVA por nube o pendrive.

## 5. Evidencias

Las capturas del proyecto deben guardarse dentro de la VM en:

```text
/proyecto/capturas/
```

Este directorio se crea en la Fase 1, junto con el resto de la estructura
`/proyecto/`. Las evidencias de la Fase 0 pueden capturarse como imagen del host
y copiarse a `/proyecto/capturas/` una vez creada esa carpeta.

Usar la convención:

```text
F0X_NN_descripcion.png
```

Capturas recomendadas para conservar el respaldo de la preparación:

| Código | Contenido | Estado |
|---|---|---|
| `F00_01_actualizacion.png` | Comando `apt full-upgrade` y resumen sin paquetes pendientes | Capturada |
| `F00_02_reinicio.png` | Comprobación de `/var/run/reboot-required` | Capturada |
| `F00_03_herramientas.png` | Instalación de paquetes base y fin correcto del comando | Capturada |
| `F00_04_entorno_base.png` | Versión, hostname, IP, zona horaria, SSH y estado de paquetes | Capturada |
| `F00_05_snapshot.png` | Snapshot `00-base-instalada` creado y verificado | Capturada |

Las capturas previas están en el host en
`revision-proyecto-isl135/evidencias/F00/` y `revision-proyecto-isl135/evidencias/F01/`.
Las imágenes principales de las fases 0 y 1 fueron copiadas y verificadas en
`/proyecto/capturas/` dentro de la VM.

La rúbrica exige capturas de las fases 1 a 8; las capturas de la fase 0 son
respaldo técnico y no sustituyen las evidencias mínimas de la fase 1.

Las evidencias de la Fase 1 están en la VM dentro de `/proyecto/capturas/`:

| Código | Contenido | Estado |
|---|---|---|
| `F01_01_hostname.png` | `hostnamectl` y resolución local IPv4 | Verificada |
| `F01_02_usuarios_grupos.png` | Usuarios, grupos y sudo | Verificada |
| `F01_03_sudo.png` | `adminsys` ejecutando `sudo whoami` | Verificada |
| `F01_04_directorios_permisos.png` | Propietarios, permisos y setgid | Verificada |
| `F01_05_herencia.png` | Herencia de grupo con `tecnico` y `visitante` | Verificada |

Las evidencias de la Fase 2 fueron respaldadas en el host en:

`revision-proyecto-isl135/evidencias/F02/`

| Código | Contenido | Estado |
|---|---|---|
| `F02_01_script.png` | Sintaxis, permisos y ejecución manual del reporte | Verificada en la VM |
| `F02_02_cron.png` | `/etc/cron.d/proyecto` y servicio cron activo | Verificada en la VM |
| `F02_03_log.png` | Ejecuciones reales de `22:00:01` y `22:30:01` | Verificada en la VM |
| `F02_04_snapshot.png` | Snapshot `02-fase2` creado y listado | Verificada en la VM |

Las evidencias de la Fase 3 fueron respaldadas en el host en:

`revision-proyecto-isl135/evidencias/F03/`

| Código | Contenido | Estado |
|---|---|---|
| `F03_01_git_local.png` | Repositorio local, primer commit e historial | Verificada en la VM |
| `F03_02_remoto_push.png` | `origin`, primer `push` y seguimiento de rama | Verificada en la VM |
| `F03_03_github.png` | Repositorio remoto con la estructura inicial | Verificada en la VM |
| `F03_04_commits_integrantes.png` | Historial con aportes y autores del grupo | Verificada en la VM |
| `F03_05_snapshot.png` | Snapshot `03-git` creado y listado | Respaldo en host y VM |

Las evidencias de la Fase 4 fueron respaldadas en el host en:

`revision-proyecto-isl135/evidencias/F04/`

| Código | Contenido | Estado |
|---|---|---|
| `F04_00_prevalidacion.png` | Debian, `trixie`, `amd64`, Git, Docker ausente y repositorio oficial | Verificada en la VM |
| `F04_01_docker_info.png` | Repositorio, servicio, versión e información de Docker | Verificada en la VM |
| `F04_02_grupo_docker.png` | Grupo `docker`, pertenencia y acceso sin `sudo` | Verificada en la VM |
| `F04_03_hello_world.png` | `Hello from Docker!`, contenedor `Exited (0)` e imagen local | Verificada en la VM |

Las evidencias de la Fase 5 fueron respaldadas en el host y en la VM:

- host: `revision-proyecto-isl135/evidencias/F05/`
- VM: `/proyecto/capturas/F05/`

| Código | Contenido | Estado |
|---|---|---|
| `F05_01_contenedor.png` | `docker ps`, `docker port` y política `unless-stopped` | Verificada en la VM |
| `F05_02_navegador.png` | Sitio del Grupo 7 en `http://localhost:8080` | Verificada en la VM |
| `F05_03_logs_montaje.png` | HTTP `200`, bind mount `RW=false` y logs limpios posteriores a la corrección | Verificada en la VM |
| `F05_04_snapshot.png` | Registro original del snapshot `05-nginx` | Verificada en la VM |

Las evidencias de la Fase 6 fueron respaldadas en el host y en la VM:

- host: `revision-proyecto-isl135/evidencias/F06/`
- VM: `/proyecto/capturas/F06/`

| Código | Contenido | Estado |
|---|---|---|
| `F06_01_dockerfile.png` | `Dockerfile`, `.dockerignore`, permisos y sitio | Verificada |
| `F06_02_build_imagen.png` | Build e imagen `servidor-grupo7:latest` | Verificada |
| `F06_03_navegador_8081.png` | Sitio del Grupo 7 en `http://localhost:8081` | Verificada |
| `F06_04_comparacion.png` | Ambos puertos `200` y diferencia entre montajes | Verificada |
| `F06_05_snapshot.png` | Snapshot `06-imagen` creado y listado | Verificada |

Las evidencias de la Fase 7 fueron respaldadas en el host y en la VM:

- host: `revision-proyecto-isl135/evidencias/F07/`
- VM: `/proyecto/capturas/F07/`

| Código | Contenido | Estado |
|---|---|---|
| `F07_01_red_custom.png` | `red-proyecto` bridge con `nginx-red` y su IPv4 | Verificada |
| `F07_02_navegador_8082.png` | Sitio del Grupo 7 en `http://localhost:8082` | Verificada |
| `F07_03_volumen.png` | Volumen `volumen-web`, montaje de `nginx-volumen` y archivos internos | Verificada |
| `F07_04_persistencia_8083.png` | Testigo y sitio tras eliminar y recrear el contenedor | Verificada |
| `F07_05_snapshot.png` | Snapshot `07-red-volumen` creado y listado | Verificada |

Las evidencias de la Fase 8 están respaldadas en el host:

- host: `revision-proyecto-isl135/evidencias/F08/`
- VM: `/proyecto/capturas/F08/` contiene las 37 capturas y los logs que se
  versionaron antes del snapshot y de la exportación.

| Código | Contenido | Estado |
|---|---|---|
| `F08_01_alpine_ping.png` | DNS interno y ping con 0 % de pérdida | Verificada |
| `F08_02_servicios_http.png` | Cuatro contenedores y puertos en `HTTP 200` | Verificada |
| `F08_03_cron_log.png` | Dos ejecuciones de cron separadas 30 minutos | Verificada |
| `F08_04_git_status_log.png` | Git limpio, historial y rama sincronizada | Verificada |
| `F08_07_verificacion_integral.png` | Verificador integral aprobado antes del reinicio | Verificada |
| `F08_09_contenedores_tras_reinicio.png` | Los cuatro contenedores vuelven tras reiniciar | Verificada |
| `F08_09e_http_tras_reinicio.png` | Los cuatro puertos responden `200` tras reiniciar | Verificada |
| `F08_10_verificacion_post_reinicio.png` | Verificación integral aprobada después del reinicio | Verificada |
| `F08_11_snapshot_08_final.png` | Snapshot `08-final` creado | Verificada |
| `F08_11a_snapshot_verificado.png` | Snapshot `08-final` listado con UUID | Verificada |

Las evidencias de la OVA están en el host y se conservan fuera de la imagen
exportada:

`revision-proyecto-isl135/evidencias/OVA/`

| Código | Contenido | Estado |
|---|---|---|
| `OVA_01_reenvios_nat.png` | Cinco reenvíos NAT antes de exportar | Verificada |
| `OVA_04_exportacion.png` | Exportación final completada | Verificada |
| `OVA_06_contenido.png` | Descriptor, disco y manifiesto dentro de la OVA | Verificada |
| `OVA_08_sha256_verificado.png` | El checksum de la OVA coincide | Verificada |
| `OVA_11_importacion.png` | Importación real como `servidor-grupo7-copia` | Verificada |
| `OVA_14_nat_copia.png` | Reenvíos NAT conservados en la copia | Verificada |
| `OVA_18_http_copia.png` | Cuatro puertos en `200` dentro de la copia | Verificada |
| `OVA_19_verificacion_copia.png` | Verificador integral aprobado en la copia | Verificada |
| `OVA_20_http_desde_host.png` | Cuatro puertos en `200` desde el host | Verificada |

El archivo `revision-proyecto-isl135/evidencias/OVA/proyecto-isl135-grupo7.ova.sha256`
conserva una copia del checksum. La OVA de 4.2 GB permanece en `Descargas` y no
debe subirse a GitHub.

Se conservaron capturas adicionales de los comandos intermedios, del contenido
dentro de la imagen, del contenedor, de los logs y de la verificación final.

Para la Fase 7 también se conservaron capturas de prevalidación, creación de
red y volumen, copia del sitio, IDs de contenedor antes y después de recrear,
prueba de persistencia, transferencia, permisos, Git y publicación.

Se conservaron capturas adicionales de la configuración SSH, README, Pull
Requests, correcciones y commits de evidencias para documentar el proceso.

El índice está en:

`/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/plantillas/capturas/INDICE.md`

## 6. Reglas para no perder el avance

- **Control exclusivo de la VM:** solo el usuario puede encender, apagar,
  reiniciar, guardar o restaurar la máquina virtual. El agente no debe ejecutar
  comandos `VBoxManage` que alteren su estado.
- **Ejecución por SSH:** el agente entrega un comando a la vez para que el
  usuario lo ejecute por SSH; después revisa la salida o captura antes de
  continuar.
- **Evidencias:** el agente evalúa las capturas del usuario y las guarda en la
  carpeta de evidencias de la fase correspondiente.
- No compartir contraseñas, tokens ni claves privadas en el chat.
- No avanzar de fase sin verificar la salida del comando anterior.
- Guardar una captura de cada verificación importante.
- Hacer `git push` al final de cada sesión.
- Tomar un snapshot antes de cada fase riesgosa, desde el host.
- Actualizar este archivo al terminar cada fase.

## 7. Última actualización

- Fecha: 30/10/2026
- Estado: las fases 0 a 8, la exportación OVA y una prueba de importación están
  completadas. El repositorio remoto `cecv9/proyecto-linux-grupo7` contiene el
  README final, la estructura del proyecto, los aportes de Azucena, Ronie y
  Daniel y las evidencias F03 a F08.
  Docker Engine `29.9.2`, Buildx `0.38.1` y Compose `5.6.1` están instalados;
  el servicio está activo; `hello-world` terminó correctamente; y `adminsys`
  y `tecnico` pertenecen al grupo `docker`. Los commits `1e582b6` y `11a1661`
  cerraron la Fase 4. El contenedor `nginx-basico` está activo, publica el
  puerto `8080` y monta `/proyecto/web` en modo solo lectura. Las respuestas
  son `HTTP 200` y los logs posteriores a la corrección del favicon están
  limpios. Los commits `428d76f`, `895e6ab` y `4498f58` cerraron la Fase 5 y
  `main...origin/main` quedó limpio. VirtualBox perdió posteriormente el
  registro de los snapshots `01-fase1`, `02-fase2` y del primer `05-nginx`;
  los estados históricos exactos no son recuperables. El 30/10/2026 se creó
  el checkpoint consolidado `05-nginx-recuperado`
  (`1260d56c-1a07-4357-aa4f-b052d35953bc`) antes de continuar. La Fase 6 quedó
  completada: `servidor-grupo7:latest` está construida y
  `nginx-personalizado` publica el puerto `8081` con contenido dentro de la
  imagen y sin bind mount. Los dos sitios responden `HTTP 200`. Los commits
  `c5f1848` y `c6fdbea` cerraron la fase y el snapshot `06-imagen`
  (`c2532f24-b760-4e38-922d-1c8e71b21fbf`) quedó creado. La Fase 7 quedó
  completada: `red-proyecto` es una red bridge local con subred
  `172.18.0.0/16`; `nginx-red` publica `8082` en `172.18.0.2/16`; y
  `nginx-volumen` publica `8083` en `172.18.0.3/16` y monta el volumen
  `volumen-web`. El testigo de persistencia sobrevivió a la recreación del
  contenedor, los cuatro puertos responden `HTTP 200` y los commits `cfb5da5`
  y `32b85e7` publicaron las evidencias. El snapshot `07-red-volumen`
  (`1abb2246-6b24-4780-8bf9-f592df9d0fab`) fue verificado y
  `main...origin/main` quedó limpio.

  En la Fase 8, Alpine resolvió `nginx-red` en `172.18.0.2` con cuatro paquetes
  recibidos y `0% packet loss`. Los cuatro contenedores y puertos respondieron
  correctamente. `verificar_proyecto.sh` se incorporó al repositorio y pasó en
  los commits `209975a`, `9956733` y `4f64f47`. Tras el reinicio, Docker y cron
  volvieron `active`, los cuatro contenedores se recuperaron solos y los cuatro
  puertos respondieron `HTTP 200`. El snapshot `08-final`
  (`485510e8-b5a1-4989-a9ed-4f43a26978cc`) fue creado y verificado.

  La OVA final es `/home/enoc/Descargas/proyecto-isl135-grupo7.ova`, mide
  `4.2 GB` y su SHA-256
  `249cae68a705ce772a249dd6d78aa3eaa86219b67b4409216c0928798067dcd4`
  fue validado con `sha256sum -c`. La importación `--dry-run` y la importación
  real como `servidor-grupo7-copia` pasaron. La copia conservó los cinco
  reenvíos NAT, arrancó por SSH, mantuvo Docker y cron activos, respondió
  `HTTP 200` en los cuatro puertos desde la VM y desde el host, y aprobó
  `verificar_proyecto.sh`. Queda pendiente únicamente el informe PDF, la
  presentación y, si se exige, la prueba de la OVA en una PC física distinta.
