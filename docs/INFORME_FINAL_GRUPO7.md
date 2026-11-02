---
title: "Proyecto Final: Servidor Linux automatizado con Docker"
subtitle: "Introducción al Software Libre — Ciclo II 2026"
author: "Grupo 7"
date: "03 de noviembre de 2026"
lang: es
---

# Portada

**Universidad de El Salvador**

**Facultad Multidisciplinaria de Occidente**

**Departamento de Ingeniería y Arquitectura**

**Ingeniería en Desarrollo de Software / Educación En Línea**

**Introducción al Software Libre — Ciclo II 2026**

## Proyecto Final: Servidor Linux automatizado con Docker

**Grupo:** 7

**Integrantes:**

- Castillo Zepeda, Azucena del Carmen — CZ08008 — @cz08008-zuz
- Calzada Vargas, Carlos Enoc — CV19058 — @cecv9
- Cruz Arce, Josué Daniel — CA23002 — @DanielCruz98-503
- Portillo Consuegra, Ronnie Odir — PC15016 — @pc15016-Ronnie

**Coordinadora de Cátedra:** MEd. Angela López de Granillo

**Tutor GT01:** Francisco Javier Morales Ayala

**Fecha de entrega:** 03 de noviembre de 2026

\newpage

# Índice

<!-- Genera el índice con Pandoc (--toc) o con Word: Referencias → Tabla de contenido. -->

\newpage

# Introducción

El proyecto implementa un servidor Linux automatizado sobre Debian 13, dentro de
una máquina virtual de VirtualBox. El servidor integra administración de usuarios
y permisos, automatización con Bash y cron, control de versiones con Git y GitHub,
y cuatro servicios web Nginx ejecutados con Docker.

La finalidad es demostrar, con evidencias verificables, que un servidor puede
configurarse de forma reproducible, monitorearse sin intervención humana y
recuperarse después de un reinicio. También se busca que cualquier integrante
pueda importar la máquina virtual y obtener el mismo entorno de trabajo.

# Objetivos

## Objetivo general

Implementar un servidor Linux automatizado mediante Docker, integrando
administración de usuarios y permisos, automatización con Bash y cron, control de
versiones y servicios web containerizados.

## Objetivos específicos

1. Configurar hostname, usuarios, grupos, sudo y permisos con herencia de grupo.
2. Automatizar un reporte del sistema cada 30 minutos.
3. Versionar el proyecto en Git y GitHub con commits de todos los integrantes.
4. Instalar Docker y desplegar cuatro servicios Nginx con técnicas distintas.
5. Construir una imagen personalizada, una red y un volumen persistente.
6. Verificar la conectividad y documentar cada fase con evidencias.

# Marco teórico

- **Debian 13:** distribución de GNU/Linux estable, con `apt`, `systemd`, `cron` y
  herramientas de administración.
- **VirtualBox:** hipervisor que permite ejecutar la VM y tomar snapshots.
- **Docker:** plataforma de contenedores. Una **imagen** es la plantilla inmutable;
  un **contenedor** es una instancia en ejecución.
- **Bind mount:** montaje de una carpeta del host dentro del contenedor.
- **Volumen:** almacenamiento gestionado por Docker que persiste aunque el
  contenedor se elimine.
- **Red bridge personalizada:** red de Docker con DNS interno para resolver
  contenedores por nombre.
- **Git y GitHub:** control de versiones distribuido y repositorio remoto.
- **cron:** planificador de tareas del sistema.
- **Nginx:** servidor web ligero usado para publicar el sitio del proyecto.

# Arquitectura de la solución

```text
Host con VirtualBox
│  NAT: 2222→22, 8080→8080, 8081→8081, 8082→8082, 8083→8083
▼
VM Debian 13 «servidor-grupo7»
├── Docker Engine
│   ├── nginx-basico        :8080  bind mount /proyecto/web (ro)
│   ├── nginx-personalizado :8081  imagen servidor-grupo7 (COPY web/)
│   ├── nginx-red           :8082  red-proyecto
│   └── nginx-volumen       :8083  volumen-web
├── cron cada 30 min → /var/log/proyecto/reporte_sistema.log
└── Git /proyecto → GitHub cecv9/proyecto-linux-grupo7
```

| Puerto | Contenedor | Técnica |
|---|---|---|
| 8080 | `nginx-basico` | Bind mount de `/proyecto/web` |
| 8081 | `nginx-personalizado` | Imagen propia `servidor-grupo7` |
| 8082 | `nginx-red` | Red personalizada `red-proyecto` |
| 8083 | `nginx-volumen` | Volumen persistente `volumen-web` |

# Fases del proyecto


## Fase 00 — Preparación del entorno

### Objetivo

Partir de una base limpia, actualizada y reproducible antes de configurar el servidor.

### Desarrollo

Se actualizó Debian 13, se instalaron las herramientas base (`curl`, `git`, `vim`, `wget`, `nano`, `cron` y `openssh-server`), se configuró la zona horaria `America/El_Salvador`, se verificaron red, SSH y paquetes, y se tomó el snapshot `00-base-instalada`.

### Comandos principales

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git vim wget nano cron openssh-server
sudo timedatectl set-timezone America/El_Salvador
hostnamectl
ip a
systemctl status ssh --no-pager
sudo dpkg --audit
```

### Evidencias

![Actualización de paquetes del sistema con apt.](../capturas/fase-00-preparacion/F00_01_actualizacion.png)

**Figura 1.** Actualización de paquetes del sistema con apt.

![Reinicio de la máquina virtual después de actualizar.](../capturas/fase-00-preparacion/F00_02_reinicio.png)

**Figura 2.** Reinicio de la máquina virtual después de actualizar.

![Instalación de curl, git, vim, wget, nano, cron y openssh-server.](../capturas/fase-00-preparacion/F00_03_herramientas.png)

**Figura 3.** Instalación de curl, git, vim, wget, nano, cron y openssh-server.

![Resumen del entorno base: hostname, red, SSH y paquetes.](../capturas/fase-00-preparacion/F00_04_entorno_base.png)

**Figura 4.** Resumen del entorno base: hostname, red, SSH y paquetes.

![Snapshot 00-base-instalada tomado desde VirtualBox.](../capturas/fase-00-preparacion/F00_05_snapshot.png)

**Figura 5.** Snapshot 00-base-instalada tomado desde VirtualBox.

![Configuración de la zona horaria.](../capturas/fase-00-preparacion/_F00_04a_timezone.png)

**Figura 6.** Configuración de la zona horaria.

![Versión de Debian.](../capturas/fase-00-preparacion/_F00_04b_debian.png)

**Figura 7.** Versión de Debian.

![Configuración y verificación del hostname.](../capturas/fase-00-preparacion/_F00_04c_hostname.png)

**Figura 8.** Configuración y verificación del hostname.

![Configuración de red.](../capturas/fase-00-preparacion/_F00_04d_red.png)

**Figura 9.** Configuración de red.

![Servicio SSH.](../capturas/fase-00-preparacion/_F00_04e_ssh.png)

**Figura 10.** Servicio SSH.

![Dpkg audit.](../capturas/fase-00-preparacion/_F00_04f_dpkg_audit.png)

**Figura 11.** Dpkg audit.

### Conclusión de la fase

El entorno quedó listo y con un punto de restauración para revertir cambios si algo falla.


## Fase 01 — Administración básica, usuarios y permisos

### Objetivo

Dar identidad al servidor y separar los roles de administración, soporte y visitantes.

### Desarrollo

Se configuró el hostname `servidor-grupo7`, se crearon los usuarios `adminsys`, `tecnico` y `visitante`, y los grupos `soporte` y `web`. `adminsys` quedó con `sudo`, `tecnico` en `soporte` y `visitante` en `web`. También se creó `/proyecto/{datos,web,scripts,capturas}`, se asignó `datos` al grupo `soporte`, `web` al grupo `web` y se activó el bit setgid (`2775`) para que los archivos nuevos hereden el grupo del directorio.

### Comandos principales

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

### Evidencias

![Hostname permanente servidor-grupo7 y resolución en /etc/hosts.](../capturas/fase-01-administracion-basica/F01_01_hostname.png)

**Figura 12.** Hostname permanente servidor-grupo7 y resolución en /etc/hosts.

![Creación de adminsys, tecnico, visitante y de los grupos soporte y web.](../capturas/fase-01-administracion-basica/F01_02_usuarios_grupos.png)

**Figura 13.** Creación de adminsys, tecnico, visitante y de los grupos soporte y web.

![Comprobación de que adminsys pertenece al grupo sudo.](../capturas/fase-01-administracion-basica/F01_03_sudo.png)

**Figura 14.** Comprobación de que adminsys pertenece al grupo sudo.

![Estructura /proyecto y permisos de datos y web.](../capturas/fase-01-administracion-basica/F01_04_directorios_permisos.png)

**Figura 15.** Estructura /proyecto y permisos de datos y web.

![Prueba de herencia de grupo gracias al setgid 2775.](../capturas/fase-01-administracion-basica/F01_05_herencia.png)

**Figura 16.** Prueba de herencia de grupo gracias al setgid 2775.

### Conclusión de la fase

Cada rol tiene acceso a lo que le corresponde y la herencia de grupo queda garantizada por el setgid.


## Fase 02 — Automatización y monitoreo

### Objetivo

Registrar el estado del servidor sin intervención humana.

### Desarrollo

Se creó `reporte_sistema.sh`, que muestra fecha y hora, hostname, usuarios conectados, espacio libre en disco, RAM disponible y cantidad de contenedores Docker activos. El script tiene permisos de ejecución y contempla el caso de que Docker no esté instalado o el daemon esté detenido. La tarea `/etc/cron.d/proyecto` lo ejecuta cada 30 minutos y agrega la salida a `/var/log/proyecto/reporte_sistema.log`.

### Comandos principales

```bash
chmod 755 /proyecto/scripts/reporte_sistema.sh
bash -n /proyecto/scripts/reporte_sistema.sh
/proyecto/scripts/reporte_sistema.sh
sudo systemctl enable --now cron
sudo cat /etc/cron.d/proyecto
tail -n 30 /var/log/proyecto/reporte_sistema.log
```

### Evidencias

![Salida completa del reporte del sistema.](../capturas/fase-02-automatizacion-monitoreo/F02_01_salida.txt)

**Figura 17.** Salida completa del reporte del sistema.

![Script reporte_sistema.sh con permisos de ejecución.](../capturas/fase-02-automatizacion-monitoreo/F02_01_script.png)

**Figura 18.** Script reporte_sistema.sh con permisos de ejecución.

![Tarea /etc/cron.d/proyecto programada cada 30 minutos.](../capturas/fase-02-automatizacion-monitoreo/F02_02_cron.png)

**Figura 19.** Tarea /etc/cron.d/proyecto programada cada 30 minutos.

![Log /var/log/proyecto/reporte_sistema.log actualizándose.](../capturas/fase-02-automatizacion-monitoreo/F02_03_log.png)

**Figura 20.** Log /var/log/proyecto/reporte_sistema.log actualizándose.

![Snapshot de cierre de la fase 2.](../capturas/fase-02-automatizacion-monitoreo/F02_04_snapshot.png)

**Figura 21.** Snapshot de cierre de la fase 2.

### Conclusión de la fase

El estado del servidor queda registrado cada 30 minutos, aunque nadie esté conectado.


## Fase 03 — Control de versiones y GitHub

### Objetivo

Versionar todo el proyecto y demostrar trabajo colaborativo.

### Desarrollo

Se inicializó el repositorio Git en `/proyecto`, se creó el primer commit con la estructura, se configuró el remoto en GitHub (`cecv9/proyecto-linux-grupo7`) y se autenticó por SSH. Se agregó el `README.md` con la descripción e instalación. El historial tiene 29 commits y participación de los 4 integrantes mediante ramas y pull requests.

### Comandos principales

```bash
cd /proyecto
git init
git config user.name "Nombre del integrante"
git config user.email "correo@ues.edu.sv"
git add .
git commit -m "Estructura inicial del proyecto"
git remote add origin git@github.com:cecv9/proyecto-linux-grupo7.git
git push -u origin main
git log --oneline --graph
git shortlog -sne
```

### Evidencias

![VM apagada antes de iniciar la práctica.](../capturas/fase-03-control-versiones/F03_00a_vm_no_iniciada.png)

**Figura 22.** VM apagada antes de iniciar la práctica.

![VM encendida en modo gráfico.](../capturas/fase-03-control-versiones/F03_00b_vm_encendida_grafica.png)

**Figura 23.** VM encendida en modo gráfico.

![Hostname y acceso SSH.](../capturas/fase-03-control-versiones/F03_00c01_hostname_ssh.png)

**Figura 24.** Hostname y acceso SSH.

![Usuario adminsys.](../capturas/fase-03-control-versiones/F03_00c02_usuario_adminsys.png)

**Figura 25.** Usuario adminsys.

![Prevalidación del proyecto.](../capturas/fase-03-control-versiones/F03_00d_prevalidacion_proyecto.png)

**Figura 26.** Prevalidación del proyecto.

![Repositorio Git local inicializado en /proyecto.](../capturas/fase-03-control-versiones/F03_01_git_local.png)

**Figura 27.** Repositorio Git local inicializado en /proyecto.

![Repositorio inicializado.](../capturas/fase-03-control-versiones/F03_01a_repositorio_inicializado.png)

**Figura 28.** Repositorio inicializado.

![Identidad de Git configurada.](../capturas/fase-03-control-versiones/F03_01b_identidad_git.png)

**Figura 29.** Identidad de Git configurada.

![Creación de .gitignore y archivos testigo.](../capturas/fase-03-control-versiones/F03_01c_gitignore_testigos.png)

**Figura 30.** Creación de .gitignore y archivos testigo.

![Lista de archivos del proyecto.](../capturas/fase-03-control-versiones/F03_01d_lista_archivos.png)

**Figura 31.** Lista de archivos del proyecto.

![Archivos preparados.](../capturas/fase-03-control-versiones/F03_01e_archivos_preparados.png)

**Figura 32.** Archivos preparados.

![Primer commit.](../capturas/fase-03-control-versiones/F03_01f_primer_commit.png)

**Figura 33.** Primer commit.

![Repositorio remoto en GitHub y primer push.](../capturas/fase-03-control-versiones/F03_02_remoto_push.png)

**Figura 34.** Repositorio remoto en GitHub y primer push.

![Repositorio creado.](../capturas/fase-03-control-versiones/F03_02a_repositorio_creado.png)

**Figura 35.** Repositorio creado.

![Prueba de SSH antes de registrar la clave.](../capturas/fase-03-control-versiones/F03_02b01_ssh_sin_clave.png)

**Figura 36.** Prueba de SSH antes de registrar la clave.

![Clave SSH generada.](../capturas/fase-03-control-versiones/F03_02b01b_clave_generada.png)

**Figura 37.** Clave SSH generada.

![Clave pública SSH.](../capturas/fase-03-control-versiones/F03_02b02_clave_publica.png)

**Figura 38.** Clave pública SSH.

![Clave SSH registrada en GitHub.](../capturas/fase-03-control-versiones/F03_02b03_clave_en_github.png)

**Figura 39.** Clave SSH registrada en GitHub.

![Autenticación SSH con GitHub.](../capturas/fase-03-control-versiones/F03_02b_ssh_github.png)

**Figura 40.** Autenticación SSH con GitHub.

![Vista del repositorio en GitHub.](../capturas/fase-03-control-versiones/F03_03_github.png)

**Figura 41.** Vista del repositorio en GitHub.

![README del proyecto.](../capturas/fase-03-control-versiones/F03_03a_readme.png)

**Figura 42.** README del proyecto.

![Error de línea nueva en el README.](../capturas/fase-03-control-versiones/F03_03a_readme_error_nueva_linea.png)

**Figura 43.** Error de línea nueva en el README.

![README corregido.](../capturas/fase-03-control-versiones/F03_03b01_readme_corregido.png)

**Figura 44.** README corregido.

![Comprobación del salto de línea final.](../capturas/fase-03-control-versiones/F03_03b02_blanco_final.png)

**Figura 45.** Comprobación del salto de línea final.

![Commit del README.](../capturas/fase-03-control-versiones/F03_03b_readme_commit.png)

**Figura 46.** Commit del README.

![Historial con commits de los cuatro integrantes.](../capturas/fase-03-control-versiones/F03_04_commits_integrantes.png)

**Figura 47.** Historial con commits de los cuatro integrantes.

![Rama de trabajo de Daniel.](../capturas/fase-03-control-versiones/F03_04a_daniel_rama.png)

**Figura 48.** Rama de trabajo de Daniel.

![Sincronización del equipo.](../capturas/fase-03-control-versiones/F03_04a_sincronizacion_equipo.png)

**Figura 49.** Sincronización del equipo.

![Error de formato en el README.](../capturas/fase-03-control-versiones/F03_04b_readme_error_formato.png)

**Figura 50.** Error de formato en el README.

![Commit de Daniel al README.](../capturas/fase-03-control-versiones/F03_04c_readme_daniel_commit.png)

**Figura 51.** Commit de Daniel al README.

![Capturas dentro de la VM.](../capturas/fase-03-control-versiones/F03_04d_capturas_en_vm.png)

**Figura 52.** Capturas dentro de la VM.

![Commit de evidencias.](../capturas/fase-03-control-versiones/F03_04e_commit_evidencias.png)

**Figura 53.** Commit de evidencias.

![Push de evidencias.](../capturas/fase-03-control-versiones/F03_04f_push_evidencias.png)

**Figura 54.** Push de evidencias.

![Commit final de evidencias.](../capturas/fase-03-control-versiones/F03_04g_commit_final_evidencias.png)

**Figura 55.** Commit final de evidencias.

![Cierre de evidencias de la fase 3.](../capturas/fase-03-control-versiones/F03_04h_cierre_evidencias.png)

**Figura 56.** Cierre de evidencias de la fase 3.

![Snapshot de cierre de la fase 3.](../capturas/fase-03-control-versiones/F03_05_snapshot.png)

**Figura 57.** Snapshot de cierre de la fase 3.

### Conclusión de la fase

El proyecto es trazable, reproducible y colaborativo desde GitHub.


## Fase 04 — Instalación y configuración de Docker

### Objetivo

Instalar Docker Engine, habilitarlo y permitir su uso sin `sudo` a los usuarios autorizados.

### Desarrollo

Se instaló Docker desde el repositorio oficial, se habilitó e inició el servicio, se agregaron `adminsys` y `tecnico` al grupo `docker`, se aplicó el cambio con `newgrp docker` y se ejecutó la prueba oficial `hello-world`. Finalmente se listaron imágenes y contenedores.

### Comandos principales

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker adminsys
sudo usermod -aG docker tecnico
newgrp docker
docker run hello-world
docker ps -a
docker images
```

### Evidencias

![Comprobación previa.](../capturas/fase-04-docker/F04_00_prevalidacion.png)

**Figura 58.** Comprobación previa.

![Comprobación previa.](../capturas/fase-04-docker/F04_00_prevalidacion.txt)

**Figura 59.** Comprobación previa.

![Comprobación previa: sesión del sistema operativo.](../capturas/fase-04-docker/F04_00_prevalidacion_01_sesion_so.png)

**Figura 60.** Comprobación previa: sesión del sistema operativo.

![Comprobación previa: git fetch.](../capturas/fase-04-docker/F04_00_prevalidacion_02_git_fetch.png)

**Figura 61.** Comprobación previa: git fetch.

![Comprobación previa: repositorio Git limpio.](../capturas/fase-04-docker/F04_00_prevalidacion_03_git_limpio.png)

**Figura 62.** Comprobación previa: repositorio Git limpio.

![Comprobación previa: Docker no instalado.](../capturas/fase-04-docker/F04_00_prevalidacion_04_docker_ausente.png)

**Figura 63.** Comprobación previa: Docker no instalado.

![Comprobación previa: repositorio Docker ausente.](../capturas/fase-04-docker/F04_00_prevalidacion_05_sin_repositorio_docker.png)

**Figura 64.** Comprobación previa: repositorio Docker ausente.

![Comprobación previa: espacio disponible en disco.](../capturas/fase-04-docker/F04_00_prevalidacion_06_espacio.png)

**Figura 65.** Comprobación previa: espacio disponible en disco.

![Comprobación previa: repositorio Docker para Trixie devuelve 404.](../capturas/fase-04-docker/F04_00_prevalidacion_07_docker_trixie_404.png)

**Figura 66.** Comprobación previa: repositorio Docker para Trixie devuelve 404.

![Comprobación previa: suites del repositorio Docker.](../capturas/fase-04-docker/F04_00_prevalidacion_08_docker_suites.png)

**Figura 67.** Comprobación previa: suites del repositorio Docker.

![Comprobación previa: contenido del repositorio Trixie.](../capturas/fase-04-docker/F04_00_prevalidacion_09_docker_trixie_contenido.png)

**Figura 68.** Comprobación previa: contenido del repositorio Trixie.

![Comprobación previa: repositorio Docker para Trixie responde 200.](../capturas/fase-04-docker/F04_00_prevalidacion_10_docker_trixie_200.png)

**Figura 69.** Comprobación previa: repositorio Docker para Trixie responde 200.

![Instalación de Docker con apt.](../capturas/fase-04-docker/F04_01_apt_install_docker.txt)

**Figura 70.** Instalación de Docker con apt.

![Actualización de paquetes con apt.](../capturas/fase-04-docker/F04_01_apt_update.png)

**Figura 71.** Actualización de paquetes con apt.

![Actualización del repositorio de Docker.](../capturas/fase-04-docker/F04_01_apt_update_docker.png)

**Figura 72.** Actualización del repositorio de Docker.

![Descarga de la clave GPG de Docker.](../capturas/fase-04-docker/F04_01_descarga_clave.png)

**Figura 73.** Descarga de la clave GPG de Docker.

![Servicio Docker activo.](../capturas/fase-04-docker/F04_01_docker_active.png)

**Figura 74.** Servicio Docker activo.

![Docker habilitado al inicio.](../capturas/fase-04-docker/F04_01_docker_enable.png)

**Figura 75.** Docker habilitado al inicio.

![Salida de docker info con cliente y servidor.](../capturas/fase-04-docker/F04_01_docker_info.png)

**Figura 76.** Salida de docker info con cliente y servidor.

![Información de Docker (detalle).](../capturas/fase-04-docker/F04_01_docker_info_detail.png)

**Figura 77.** Información de Docker (detalle).

![Información de Docker (detalle, recorte).](../capturas/fase-04-docker/F04_01_docker_info_detail_recorte.png)

**Figura 78.** Información de Docker (detalle, recorte).

![Versión de Docker.](../capturas/fase-04-docker/F04_01_docker_version.png)

**Figura 79.** Versión de Docker.

![Fuente de Docker creada.](../capturas/fase-04-docker/F04_01_fuente_docker_creada.png)

**Figura 80.** Fuente de Docker creada.

![Fuente de Docker verificada.](../capturas/fase-04-docker/F04_01_fuente_docker_verificada.png)

**Figura 81.** Fuente de Docker verificada.

![Instalación.](../capturas/fase-04-docker/F04_01_instalacion.txt)

**Figura 82.** Instalación.

![Directorio de keyrings.](../capturas/fase-04-docker/F04_01_keyrings.png)

**Figura 83.** Directorio de keyrings.

![Permisos de la clave GPG.](../capturas/fase-04-docker/F04_01_permiso_clave.png)

**Figura 84.** Permisos de la clave GPG.

![Prerrequisitos instalados.](../capturas/fase-04-docker/F04_01_prerequisitos.png)

**Figura 85.** Prerrequisitos instalados.

![Adminsys usando Docker sin sudo.](../capturas/fase-04-docker/F04_02_adminsys_sin_sudo.png)

**Figura 86.** Adminsys usando Docker sin sudo.

![Consulta del grupo docker con getent.](../capturas/fase-04-docker/F04_02_getent_group_docker.png)

**Figura 87.** Consulta del grupo docker con getent.

![Grupo docker.](../capturas/fase-04-docker/F04_02_grupo_docker.png)

**Figura 88.** Grupo docker.

![Grupo docker.](../capturas/fase-04-docker/F04_02_grupo_docker.txt)

**Figura 89.** Grupo docker.

![ID y grupos de adminsys.](../capturas/fase-04-docker/F04_02_id_adminsys.png)

**Figura 90.** ID y grupos de adminsys.

![ID y grupos de tecnico.](../capturas/fase-04-docker/F04_02_id_tecnico.png)

**Figura 91.** ID y grupos de tecnico.

![ID y grupos de tecnico recorte.](../capturas/fase-04-docker/F04_02_id_tecnico_recorte.png)

**Figura 92.** ID y grupos de tecnico recorte.

![Nueva sesión con el grupo docker.](../capturas/fase-04-docker/F04_02_newgrp_docker.png)

**Figura 93.** Nueva sesión con el grupo docker.

![Tecnico usando Docker sin sudo.](../capturas/fase-04-docker/F04_02_tecnico_sin_sudo.png)

**Figura 94.** Tecnico usando Docker sin sudo.

![Adminsys agregado al grupo docker.](../capturas/fase-04-docker/F04_02_usermod_adminsys.png)

**Figura 95.** Adminsys agregado al grupo docker.

![Tecnico agregado al grupo docker.](../capturas/fase-04-docker/F04_02_usermod_tecnico.png)

**Figura 96.** Tecnico agregado al grupo docker.

![Imágenes Docker disponibles.](../capturas/fase-04-docker/F04_03_docker_images.png)

**Figura 97.** Imágenes Docker disponibles.

![Contenedores con docker ps -a.](../capturas/fase-04-docker/F04_03_docker_ps_a.png)

**Figura 98.** Contenedores con docker ps -a.

![Prueba oficial hello-world de Docker.](../capturas/fase-04-docker/F04_03_hello_world.png)

**Figura 99.** Prueba oficial hello-world de Docker.

![Prueba hello-world.](../capturas/fase-04-docker/F04_03_hello_world.txt)

**Figura 100.** Prueba hello-world.

![Ejecución de la prueba hello-world.](../capturas/fase-04-docker/F04_03_hello_world_01_ejecucion.png)

**Figura 101.** Ejecución de la prueba hello-world.

![Commit de evidencias de la fase 4.](../capturas/fase-04-docker/F04_04_commit.png)

**Figura 102.** Commit de evidencias de la fase 4.

![Evidencias dentro de la VM.](../capturas/fase-04-docker/F04_04_evidencias_en_vm.png)

**Figura 103.** Evidencias dentro de la VM.

![Preparación de evidencias con git add.](../capturas/fase-04-docker/F04_04_git_add.png)

**Figura 104.** Preparación de evidencias con git add.

![Revisión de cambios preparados con git diff --cached.](../capturas/fase-04-docker/F04_04_git_diff_cached.png)

**Figura 105.** Revisión de cambios preparados con git diff --cached.

![Snapshot.](../capturas/fase-04-docker/F04_04_snapshot.png)

**Figura 106.** Snapshot.

![Snapshot.](../capturas/fase-04-docker/F04_04_snapshot.txt)

**Figura 107.** Snapshot.

![Verificación de nombres fallida.](../capturas/fase-04-docker/F04_04_verificacion_nombres_fallida.png)

**Figura 108.** Verificación de nombres fallida.

### Conclusión de la fase

Docker funciona y los usuarios del grupo `docker` pueden administrarlo sin `sudo`.


## Fase 05 — Servidor web Nginx básico

### Objetivo

Publicar el sitio del proyecto en el puerto 8080 con un bind mount.

### Desarrollo

Se creó el sitio en `/proyecto/web/index.html`, se ejecutó `nginx-basico` en segundo plano con `-d`, se mapeó el puerto `8080` del host al `80` del contenedor y se montó `/proyecto/web` en `/usr/share/nginx/html` en modo solo lectura. Se verificó la respuesta HTTP y se revisaron los logs.

### Comandos principales

```bash
docker run -d --name nginx-basico --restart unless-stopped \
  -p 8080:80 -v /proyecto/web:/usr/share/nginx/html:ro nginx:latest
curl -I http://localhost:8080
docker logs --tail 20 nginx-basico
docker inspect -f '{range .Mounts}{.Source} -> {.Destination}{"\n"}{end}' nginx-basico
```

### Evidencias

![Contenedor nginx-basico en ejecución.](../capturas/fase-05-nginx-basico/F05_01_contenedor.png)

**Figura 109.** Contenedor nginx-basico en ejecución.

![Contenedores activos con docker ps.](../capturas/fase-05-nginx-basico/F05_01a_docker_ps.png)

**Figura 110.** Contenedores activos con docker ps.

![Puerto publicado con docker port.](../capturas/fase-05-nginx-basico/F05_01b_docker_port.png)

**Figura 111.** Puerto publicado con docker port.

![Política de reinicio del contenedor.](../capturas/fase-05-nginx-basico/F05_01c_politica_reinicio.png)

**Figura 112.** Política de reinicio del contenedor.

![Sitio del proyecto visible en http://localhost:8080.](../capturas/fase-05-nginx-basico/F05_02_navegador.png)

**Figura 113.** Sitio del proyecto visible en http://localhost:8080.

![Logs y montaje del contenedor.](../capturas/fase-05-nginx-basico/F05_03_logs_montaje.png)

**Figura 114.** Logs y montaje del contenedor.

![HTTP.](../capturas/fase-05-nginx-basico/F05_03a_http.png)

**Figura 115.** HTTP.

![Montaje del contenedor.](../capturas/fase-05-nginx-basico/F05_03b_montaje.png)

**Figura 116.** Montaje del contenedor.

![Logs sin errores.](../capturas/fase-05-nginx-basico/F05_03c_logs_limpios.png)

**Figura 117.** Logs sin errores.

![Snapshot.](../capturas/fase-05-nginx-basico/F05_04_snapshot.png)

**Figura 118.** Snapshot.

### Conclusión de la fase

El sitio se sirve desde el host y los cambios en `/proyecto/web` se reflejan sin reconstruir la imagen.


## Fase 06 — Imagen personalizada con Dockerfile

### Objetivo

Construir una imagen propia y compararla con la imagen oficial de Nginx.

### Desarrollo

Se creó el `Dockerfile` con `FROM nginx:latest`, `COPY web/ /usr/share/nginx/html/`, `EXPOSE 80` y `CMD ["nginx", "-g", "daemon off;"]`. Se construyó la imagen `servidor-grupo7`, se ejecutó `nginx-personalizado` en el puerto `8081` y se comparó con `nginx-basico`: la imagen propia lleva el contenido dentro y no depende de un montaje del host.

### Comandos principales

```bash
cd /proyecto
docker build -t servidor-grupo7 .
docker run -d --name nginx-personalizado --restart unless-stopped \
  -p 8081:80 servidor-grupo7
curl -I http://localhost:8081
docker inspect -f '{json .Mounts}' nginx-personalizado
```

### Evidencias

![Comprobación previa.](../capturas/fase-06-imagen-personalizada/F06_00_prevalidacion.png)

**Figura 119.** Comprobación previa.

![Dockerfile personalizado del proyecto.](../capturas/fase-06-imagen-personalizada/F06_01_dockerfile.png)

**Figura 120.** Dockerfile personalizado del proyecto.

![Dockerfile del proyecto.](../capturas/fase-06-imagen-personalizada/F06_01a_dockerfile.png)

**Figura 121.** Dockerfile del proyecto.

![Construcción de la imagen servidor-grupo7.](../capturas/fase-06-imagen-personalizada/F06_02_build_imagen.png)

**Figura 122.** Construcción de la imagen servidor-grupo7.

![Build de la imagen.](../capturas/fase-06-imagen-personalizada/F06_02a_build.png)

**Figura 123.** Build de la imagen.

![Sitio servido desde la imagen propia en 8081.](../capturas/fase-06-imagen-personalizada/F06_03_navegador_8081.png)

**Figura 124.** Sitio servido desde la imagen propia en 8081.

![Ejecución del contenedor.](../capturas/fase-06-imagen-personalizada/F06_03a_container_run.png)

**Figura 125.** Ejecución del contenedor.

![Contenedor.](../capturas/fase-06-imagen-personalizada/F06_03b_contenedor.png)

**Figura 126.** Contenedor.

![Contenido servido por HTTP.](../capturas/fase-06-imagen-personalizada/F06_03c_http_contenido.png)

**Figura 127.** Contenido servido por HTTP.

![Montaje y logs.](../capturas/fase-06-imagen-personalizada/F06_03d_montaje_logs.png)

**Figura 128.** Montaje y logs.

![Comparación entre Nginx oficial y la imagen personalizada.](../capturas/fase-06-imagen-personalizada/F06_04_comparacion.png)

**Figura 129.** Comparación entre Nginx oficial y la imagen personalizada.

![Snapshot.](../capturas/fase-06-imagen-personalizada/F06_05_snapshot.png)

**Figura 130.** Snapshot.

![Verificación final de la fase 6.](../capturas/fase-06-imagen-personalizada/F06_06_verificacion_final.png)

**Figura 131.** Verificación final de la fase 6.

### Conclusión de la fase

La imagen es autocontenida y reproducible; el puerto 8081 funciona sin bind mount.


## Fase 07 — Redes y volúmenes de Docker

### Objetivo

Aislar servicios en una red propia y conservar contenido en un volumen persistente.

### Desarrollo

Se creó la red `red-proyecto` y el contenedor `nginx-red` en el puerto `8082`; se comprobó con `docker network inspect` que está conectado. También se creó el volumen `volumen-web` y el contenedor `nginx-volumen` en el puerto `8083`; se copió el sitio al volumen y se demostró que el contenido sobrevive al eliminar y recrear el contenedor.

### Comandos principales

```bash
docker network create red-proyecto
docker run -d --name nginx-red --restart unless-stopped \
  --network red-proyecto -p 8082:80 nginx:latest
docker volume create volumen-web
docker run -d --name nginx-volumen --restart unless-stopped \
  -p 8083:80 -v volumen-web:/usr/share/nginx/html nginx:latest
docker network inspect red-proyecto
docker volume inspect volumen-web
docker cp /proyecto/web/index.html nginx-volumen:/usr/share/nginx/html/index.html
docker cp /proyecto/web/favicon.svg nginx-volumen:/usr/share/nginx/html/favicon.svg
```

### Evidencias

![Commit de la fase 7.](../capturas/fase-07-redes-volumenes/F07_00_commit.png)

**Figura 132.** Commit de la fase 7.

![Commit del snapshot de la fase 7.](../capturas/fase-07-redes-volumenes/F07_00_commit_snapshot.png)

**Figura 133.** Commit del snapshot de la fase 7.

![Contenedor antes de recrear.](../capturas/fase-07-redes-volumenes/F07_00_contenedor_antes_recrear.png)

**Figura 134.** Contenedor antes de recrear.

![Contenedor ausente.](../capturas/fase-07-redes-volumenes/F07_00_contenedor_ausente.png)

**Figura 135.** Contenedor ausente.

![Contenedor eliminado.](../capturas/fase-07-redes-volumenes/F07_00_contenedor_eliminado.png)

**Figura 136.** Contenedor eliminado.

![Contenido servido en 8082.](../capturas/fase-07-redes-volumenes/F07_00_contenido_8082.png)

**Figura 137.** Contenido servido en 8082.

![Contenido servido en 8083.](../capturas/fase-07-redes-volumenes/F07_00_contenido_8083.png)

**Figura 138.** Contenido servido en 8083.

![Contenido en 8083 tras recrear.](../capturas/fase-07-redes-volumenes/F07_00_contenido_8083_recreado.png)

**Figura 139.** Contenido en 8083 tras recrear.

![Copia de favicon.svg al volumen.](../capturas/fase-07-redes-volumenes/F07_00_cp_favicon.png)

**Figura 140.** Copia de favicon.svg al volumen.

![Copia de index.html al volumen.](../capturas/fase-07-redes-volumenes/F07_00_cp_index.png)

**Figura 141.** Copia de index.html al volumen.

![Creación de la red personalizada.](../capturas/fase-07-redes-volumenes/F07_00_creacion_red.png)

**Figura 142.** Creación de la red personalizada.

![Revisión de espacios con git diff --check.](../capturas/fase-07-redes-volumenes/F07_00_diff_check.png)

**Figura 143.** Revisión de espacios con git diff --check.

![Diferencia de evidencias con git diff.](../capturas/fase-07-redes-volumenes/F07_00_diff_evidencias.png)

**Figura 144.** Diferencia de evidencias con git diff.

![Diferencia del snapshot con git diff.](../capturas/fase-07-redes-volumenes/F07_00_diff_snapshot.png)

**Figura 145.** Diferencia del snapshot con git diff.

![Evidencias en la VM antes de ajustar permisos.](../capturas/fase-07-redes-volumenes/F07_00_evidencias_en_vm_antes_permisos.png)

**Figura 146.** Evidencias en la VM antes de ajustar permisos.

![Preparación de evidencias con git add.](../capturas/fase-07-redes-volumenes/F07_00_git_add.png)

**Figura 147.** Preparación de evidencias con git add.

![Preparación del snapshot con git add.](../capturas/fase-07-redes-volumenes/F07_00_git_add_snapshot.png)

**Figura 148.** Preparación del snapshot con git add.

![Estado de Git antes del commit.](../capturas/fase-07-redes-volumenes/F07_00_git_antes_commit.png)

**Figura 149.** Estado de Git antes del commit.

![Estado de Git del snapshot.](../capturas/fase-07-redes-volumenes/F07_00_git_snapshot.png)

**Figura 150.** Estado de Git del snapshot.

![Respuesta HTTP en 8082.](../capturas/fase-07-redes-volumenes/F07_00_http_8082.png)

**Figura 151.** Respuesta HTTP en 8082.

![Respuesta HTTP en 8083.](../capturas/fase-07-redes-volumenes/F07_00_http_8083.png)

**Figura 152.** Respuesta HTTP en 8083.

![Respuesta HTTP en 8083 tras recrear.](../capturas/fase-07-redes-volumenes/F07_00_http_8083_recreado.png)

**Figura 153.** Respuesta HTTP en 8083 tras recrear.

![Respuesta HTTP final.](../capturas/fase-07-redes-volumenes/F07_00_http_final.png)

**Figura 154.** Respuesta HTTP final.

![Logs del contenedor 8082.](../capturas/fase-07-redes-volumenes/F07_00_logs_8082.png)

**Figura 155.** Logs del contenedor 8082.

![Logs del contenedor 8083.](../capturas/fase-07-redes-volumenes/F07_00_logs_8083.png)

**Figura 156.** Logs del contenedor 8083.

![Contenido del volumen.](../capturas/fase-07-redes-volumenes/F07_00_ls_volumen.png)

**Figura 157.** Contenido del volumen.

![Contenedor nginx-red creado.](../capturas/fase-07-redes-volumenes/F07_00_nginx_red_creado.png)

**Figura 158.** Contenedor nginx-red creado.

![Estado de nginx-red.](../capturas/fase-07-redes-volumenes/F07_00_nginx_red_estado.png)

**Figura 159.** Estado de nginx-red.

![Inspección de nginx-red.](../capturas/fase-07-redes-volumenes/F07_00_nginx_red_inspect.png)

**Figura 160.** Inspección de nginx-red.

![Contenedor nginx-volumen creado.](../capturas/fase-07-redes-volumenes/F07_00_nginx_volumen_creado.png)

**Figura 161.** Contenedor nginx-volumen creado.

![Inspección de nginx-volumen.](../capturas/fase-07-redes-volumenes/F07_00_nginx_volumen_inspect.png)

**Figura 162.** Inspección de nginx-volumen.

![Contenedor nginx-volumen recreado.](../capturas/fase-07-redes-volumenes/F07_00_nginx_volumen_recreado.png)

**Figura 163.** Contenedor nginx-volumen recreado.

![Permisos de las evidencias.](../capturas/fase-07-redes-volumenes/F07_00_permisos_evidencias.png)

**Figura 164.** Permisos de las evidencias.

![Permisos del snapshot.](../capturas/fase-07-redes-volumenes/F07_00_permisos_snapshot.png)

**Figura 165.** Permisos del snapshot.

![Comprobación previa: identidad del usuario.](../capturas/fase-07-redes-volumenes/F07_00_prevalidacion_01_identidad.png)

**Figura 166.** Comprobación previa: identidad del usuario.

![Comprobación previa: contenedores activos.](../capturas/fase-07-redes-volumenes/F07_00_prevalidacion_02_contenedores.png)

**Figura 167.** Comprobación previa: contenedores activos.

![Comprobación previa: respuestas HTTP anteriores.](../capturas/fase-07-redes-volumenes/F07_00_prevalidacion_03_http_previos.png)

**Figura 168.** Comprobación previa: respuestas HTTP anteriores.

![Comprobación previa: estado de Git.](../capturas/fase-07-redes-volumenes/F07_00_prevalidacion_04_git.png)

**Figura 169.** Comprobación previa: estado de Git.

![Comprobación previa: nombres de contenedores libres.](../capturas/fase-07-redes-volumenes/F07_00_prevalidacion_05_nombres_libres.png)

**Figura 170.** Comprobación previa: nombres de contenedores libres.

![Comprobación previa: puertos libres.](../capturas/fase-07-redes-volumenes/F07_00_prevalidacion_06_puertos_libres.png)

**Figura 171.** Comprobación previa: puertos libres.

![Comprobación previa: red libre.](../capturas/fase-07-redes-volumenes/F07_00_prevalidacion_07_red_libre.png)

**Figura 172.** Comprobación previa: red libre.

![Comprobación previa: volumen libre.](../capturas/fase-07-redes-volumenes/F07_00_prevalidacion_08_volumen_libre.png)

**Figura 173.** Comprobación previa: volumen libre.

![Push de la fase 7.](../capturas/fase-07-redes-volumenes/F07_00_push.png)

**Figura 174.** Push de la fase 7.

![Push del snapshot.](../capturas/fase-07-redes-volumenes/F07_00_push_snapshot.png)

**Figura 175.** Push del snapshot.

![Estado final de la red.](../capturas/fase-07-redes-volumenes/F07_00_red_final.png)

**Figura 176.** Estado final de la red.

![Inspección inicial de la red.](../capturas/fase-07-redes-volumenes/F07_00_red_inspect_inicial.png)

**Figura 177.** Inspección inicial de la red.

![Red registrada.](../capturas/fase-07-redes-volumenes/F07_00_red_registrada.png)

**Figura 178.** Red registrada.

![Estado final de los servicios.](../capturas/fase-07-redes-volumenes/F07_00_servicios_final.png)

**Figura 179.** Estado final de los servicios.

![Archivo testigo creado en el volumen.](../capturas/fase-07-redes-volumenes/F07_00_testigo_creado.png)

**Figura 180.** Archivo testigo creado en el volumen.

![Archivo testigo después de recrear.](../capturas/fase-07-redes-volumenes/F07_00_testigo_despues_recrear.png)

**Figura 181.** Archivo testigo después de recrear.

![Transferencia de evidencias a la VM.](../capturas/fase-07-redes-volumenes/F07_00_transferencia_evidencias.png)

**Figura 182.** Transferencia de evidencias a la VM.

![Transferencia del snapshot.](../capturas/fase-07-redes-volumenes/F07_00_transferencia_snapshot.png)

**Figura 183.** Transferencia del snapshot.

![Verificación de permisos.](../capturas/fase-07-redes-volumenes/F07_00_verificacion_permisos.png)

**Figura 184.** Verificación de permisos.

![Volumen creado.](../capturas/fase-07-redes-volumenes/F07_00_volumen_creado.png)

**Figura 185.** Volumen creado.

![Estado del volumen después de eliminar el contenedor.](../capturas/fase-07-redes-volumenes/F07_00_volumen_despues_eliminar.png)

**Figura 186.** Estado del volumen después de eliminar el contenedor.

![Inspección del volumen.](../capturas/fase-07-redes-volumenes/F07_00_volumen_inspect.png)

**Figura 187.** Inspección del volumen.

![Volumen registrado.](../capturas/fase-07-redes-volumenes/F07_00_volumen_registrado.png)

**Figura 188.** Volumen registrado.

![Red personalizada red-proyecto creada.](../capturas/fase-07-redes-volumenes/F07_01_red_custom.png)

**Figura 189.** Red personalizada red-proyecto creada.

![Sitio servido desde nginx-red en 8082.](../capturas/fase-07-redes-volumenes/F07_02_navegador_8082.png)

**Figura 190.** Sitio servido desde nginx-red en 8082.

![Volumen volumen-web creado e inspeccionado.](../capturas/fase-07-redes-volumenes/F07_03_volumen.png)

**Figura 191.** Volumen volumen-web creado e inspeccionado.

![Sitio servido desde nginx-volumen en 8083.](../capturas/fase-07-redes-volumenes/F07_04_navegador_8083.png)

**Figura 192.** Sitio servido desde nginx-volumen en 8083.

![Persistencia del contenido después de recrear el contenedor.](../capturas/fase-07-redes-volumenes/F07_04_persistencia_8083.png)

**Figura 193.** Persistencia del contenido después de recrear el contenedor.

![Snapshot.](../capturas/fase-07-redes-volumenes/F07_05_snapshot.png)

**Figura 194.** Snapshot.

![Creación del snapshot.](../capturas/fase-07-redes-volumenes/F07_05_snapshot_creacion.png)

**Figura 195.** Creación del snapshot.

![Listado de snapshots.](../capturas/fase-07-redes-volumenes/F07_05_snapshot_listado.png)

**Figura 196.** Listado de snapshots.

![Navegador 8083 sin URL.](../capturas/fase-07-redes-volumenes/_F07_04_navegador_8083_sin_url.png)

**Figura 197.** Navegador 8083 sin URL.

### Conclusión de la fase

Los contenedores se comunican por nombre y el contenido del volumen persiste aunque el contenedor se recree.


## Fase 08 — Pruebas y verificación final

### Objetivo

Demostrar que todos los servicios, la automatización y el repositorio funcionan juntos.

### Desarrollo

Se ejecutó un contenedor Alpine en `red-proyecto` para hacer ping a `nginx-red` por nombre, se comprobaron los 4 puertos con `curl`, se revisaron cron y el log, y se ejecutó `verificar_proyecto.sh`, que valida hostname, usuarios, grupos, permisos, script, cron, Docker, contenedores, red, volumen y Git. También se reinició la VM y se confirmó que los servicios vuelven a arrancar.

### Comandos principales

```bash
docker run --rm --network red-proyecto alpine ping -c 2 nginx-red
for p in 8080 8081 8082 8083; do
  curl -s -o /dev/null -w "$p -> %{http_code}\n" http://localhost:$p
done
/proyecto/scripts/verificar_proyecto.sh; echo "Código de salida: $?"
git -C /proyecto status -sb
sudo reboot
```

### Evidencias

![Ping desde Alpine a nginx-red usando la red personalizada.](../capturas/fase-08-pruebas-verificacion/F08_01_alpine_ping.png)

**Figura 198.** Ping desde Alpine a nginx-red usando la red personalizada.

![Los cuatro puertos responden HTTP 200.](../capturas/fase-08-pruebas-verificacion/F08_02_servicios_http.png)

**Figura 199.** Los cuatro puertos responden HTTP 200.

![Contenedores activos con docker ps.](../capturas/fase-08-pruebas-verificacion/F08_02a_docker_ps.png)

**Figura 200.** Contenedores activos con docker ps.

![Cron activo y log actualizado.](../capturas/fase-08-pruebas-verificacion/F08_03_cron_log.png)

**Figura 201.** Cron activo y log actualizado.

![Git status limpio y log de commits.](../capturas/fase-08-pruebas-verificacion/F08_04_git_status_log.png)

**Figura 202.** Git status limpio y log de commits.

![Estado del repositorio Git.](../capturas/fase-08-pruebas-verificacion/F08_04a_git_status.png)

**Figura 203.** Estado del repositorio Git.

![Verificador integral listo.](../capturas/fase-08-pruebas-verificacion/F08_05_verificador_listo.png)

**Figura 204.** Verificador integral listo.

![Prevalidación del script verificador.](../capturas/fase-08-pruebas-verificacion/F08_05a_prevalidacion_script.png)

**Figura 205.** Prevalidación del script verificador.

![Transferencia del verificador a la VM.](../capturas/fase-08-pruebas-verificacion/F08_05b_transferencia_verificador.png)

**Figura 206.** Transferencia del verificador a la VM.

![Instalación del script verificador.](../capturas/fase-08-pruebas-verificacion/F08_05c_instalacion_script.png)

**Figura 207.** Instalación del script verificador.

![Permiso de ejecución del verificador.](../capturas/fase-08-pruebas-verificacion/F08_05d_permiso_verificador.png)

**Figura 208.** Permiso de ejecución del verificador.

![Carpeta de capturas en la VM.](../capturas/fase-08-pruebas-verificacion/F08_05e_carpeta_capturas.png)

**Figura 209.** Carpeta de capturas en la VM.

![Verificación integral del proyecto.](../capturas/fase-08-pruebas-verificacion/F08_06_verificacion_integral.txt)

**Figura 210.** Verificación integral del proyecto.

![Verificación integral con fallo de Git.](../capturas/fase-08-pruebas-verificacion/F08_06_verificacion_integral_fallo_git.png)

**Figura 211.** Verificación integral con fallo de Git.

![Transferencia de capturas a la VM.](../capturas/fase-08-pruebas-verificacion/F08_06a_transferencia_capturas.png)

**Figura 212.** Transferencia de capturas a la VM.

![Evidencias dentro de la VM.](../capturas/fase-08-pruebas-verificacion/F08_06b_evidencias_en_vm.png)

**Figura 213.** Evidencias dentro de la VM.

![Cambios pendientes en Git.](../capturas/fase-08-pruebas-verificacion/F08_06c_cambios_pendientes.png)

**Figura 214.** Cambios pendientes en Git.

![Preparación de cambios con git add.](../capturas/fase-08-pruebas-verificacion/F08_06d_git_add.png)

**Figura 215.** Preparación de cambios con git add.

![Cambios preparados para commit.](../capturas/fase-08-pruebas-verificacion/F08_06e_cambios_preparados.png)

**Figura 216.** Cambios preparados para commit.

![Verificación integral aprobada.](../capturas/fase-08-pruebas-verificacion/F08_07_verificacion_integral.png)

**Figura 217.** Verificación integral aprobada.

![Verificación integral del proyecto.](../capturas/fase-08-pruebas-verificacion/F08_07_verificacion_integral.txt)

**Figura 218.** Verificación integral del proyecto.

![Commit de evidencias.](../capturas/fase-08-pruebas-verificacion/F08_07a_commit_evidencias.png)

**Figura 219.** Commit de evidencias.

![Log copiado como evidencia.](../capturas/fase-08-pruebas-verificacion/F08_07b_log_copiado.png)

**Figura 220.** Log copiado como evidencia.

![Transferencia final de evidencias.](../capturas/fase-08-pruebas-verificacion/F08_07c_transferencia_final.png)

**Figura 221.** Transferencia final de evidencias.

![Archivos nuevos detectados por Git.](../capturas/fase-08-pruebas-verificacion/F08_07d_git_nuevos.png)

**Figura 222.** Archivos nuevos detectados por Git.

![Transferencia de las últimas capturas.](../capturas/fase-08-pruebas-verificacion/F08_07e_transferencia_ultimas.png)

**Figura 223.** Transferencia de las últimas capturas.

![Git add final.](../capturas/fase-08-pruebas-verificacion/F08_07f_git_add_final.png)

**Figura 224.** Git add final.

![Cambios finales preparados.](../capturas/fase-08-pruebas-verificacion/F08_07g_cambios_finales_preparados.png)

**Figura 225.** Cambios finales preparados.

![Commit de verificación aprobada.](../capturas/fase-08-pruebas-verificacion/F08_07h_commit_verificacion_aprobada.png)

**Figura 226.** Commit de verificación aprobada.

![Push a GitHub.](../capturas/fase-08-pruebas-verificacion/F08_08_push.png)

**Figura 227.** Push a GitHub.

![Repositorio limpio.](../capturas/fase-08-pruebas-verificacion/F08_08a_git_limpio.png)

**Figura 228.** Repositorio limpio.

![Los contenedores vuelven a arrancar después del reinicio.](../capturas/fase-08-pruebas-verificacion/F08_09_contenedores_tras_reinicio.png)

**Figura 229.** Los contenedores vuelven a arrancar después del reinicio.

![Reinicio de la VM.](../capturas/fase-08-pruebas-verificacion/F08_09a_reinicio.png)

**Figura 230.** Reinicio de la VM.

![Reconexión SSH después del reinicio.](../capturas/fase-08-pruebas-verificacion/F08_09b_reconexion.png)

**Figura 231.** Reconexión SSH después del reinicio.

![Cambio al directorio /proyecto.](../capturas/fase-08-pruebas-verificacion/F08_09c_cd_proyecto.png)

**Figura 232.** Cambio al directorio /proyecto.

![Servicios después del reinicio.](../capturas/fase-08-pruebas-verificacion/F08_09d_servicios_tras_reinicio.png)

**Figura 233.** Servicios después del reinicio.

![Respuesta HTTP después del reinicio.](../capturas/fase-08-pruebas-verificacion/F08_09e_http_tras_reinicio.png)

**Figura 234.** Respuesta HTTP después del reinicio.

![Verificación posterior al reinicio.](../capturas/fase-08-pruebas-verificacion/F08_10_post_reinicio.txt)

**Figura 235.** Verificación posterior al reinicio.

![Verificación integral posterior al reinicio.](../capturas/fase-08-pruebas-verificacion/F08_10_verificacion_post_reinicio.png)

**Figura 236.** Verificación integral posterior al reinicio.

![Log posterior al reinicio.](../capturas/fase-08-pruebas-verificacion/F08_10a_log_post_reinicio_copiado.png)

**Figura 237.** Log posterior al reinicio.

![Transferencia final de evidencias.](../capturas/fase-08-pruebas-verificacion/F08_10b_transferencia_final.png)

**Figura 238.** Transferencia final de evidencias.

![Revisión después del reinicio.](../capturas/fase-08-pruebas-verificacion/F08_10c_revision_reinicio.png)

**Figura 239.** Revisión después del reinicio.

![Preparación de evidencias del reinicio con git add.](../capturas/fase-08-pruebas-verificacion/F08_10d_git_add_reinicio.png)

**Figura 240.** Preparación de evidencias del reinicio con git add.

![Cambios del reinicio preparados.](../capturas/fase-08-pruebas-verificacion/F08_10e_cambios_reinicio_preparados.png)

**Figura 241.** Cambios del reinicio preparados.

![Commit de las evidencias del reinicio.](../capturas/fase-08-pruebas-verificacion/F08_10f_commit_reinicio.png)

**Figura 242.** Commit de las evidencias del reinicio.

![Push final.](../capturas/fase-08-pruebas-verificacion/F08_10g_push_final.png)

**Figura 243.** Push final.

![Repositorio limpio al final.](../capturas/fase-08-pruebas-verificacion/F08_10h_git_limpio_final.png)

**Figura 244.** Repositorio limpio al final.

![Snapshot 08-final creado.](../capturas/fase-08-pruebas-verificacion/F08_11_snapshot_08_final.png)

**Figura 245.** Snapshot 08-final creado.

![Snapshot 08-final verificado.](../capturas/fase-08-pruebas-verificacion/F08_11a_snapshot_verificado.png)

**Figura 246.** Snapshot 08-final verificado.

![Listado de snapshots antes del cierre.](../capturas/fase-08-pruebas-verificacion/F08_11a_snapshots_prefinal.png)

**Figura 247.** Listado de snapshots antes del cierre.

### Conclusión de la fase

El proyecto queda verificado de extremo a extremo y resiste un reinicio de la máquina virtual.


## Exportación e importación de la OVA

### Objetivo

Demostrar que la máquina virtual se puede exportar como `proyecto-isl135-grupo7.ova`,
verificar su integridad con SHA-256, importarla en otra copia y comprobar que los
cuatro servicios siguen funcionando.

### Desarrollo

1. Se verificaron los reenvíos NAT `2222`, `8080`, `8081`, `8082` y `8083`.
2. Se apagó la VM y se exportó a OVA con `VBoxManage export`.
3. Se generó y verificó el SHA-256.
4. Se importó como `servidor-grupo7-copia` con MAC regenerada.
5. Se comprobó que los contenedores y los cuatro puertos responden `200`.

### Comandos principales

```bash
# En el host, con la VM apagada
VBoxManage export "Debian 13" --output "proyecto-isl135-grupo7.ova" --manifest
sha256sum proyecto-isl135-grupo7.ova | tee proyecto-isl135-grupo7.ova.sha256
sha256sum -c proyecto-isl135-grupo7.ova.sha256

# Importar como copia independiente
VBoxManage import "proyecto-isl135-grupo7.ova" --vsys 0 --vmname "servidor-grupo7-copia"
VBoxManage modifyvm "servidor-grupo7-copia" --macaddress1 auto
VBoxManage showvminfo "servidor-grupo7-copia" --machinereadable | grep -i Forwarding
```

### Evidencias

![Reenvíos NAT configurados antes de exportar.](../capturas/ova-exportacion/OVA_01_reenvios_nat.png)

**Figura 248.** Reenvíos NAT configurados antes de exportar.

![Espacio disponible en disco antes de la exportación.](../capturas/ova-exportacion/OVA_02_espacio_disco.png)

**Figura 249.** Espacio disponible en disco antes de la exportación.

![VM apagada correctamente antes de exportar.](../capturas/ova-exportacion/OVA_03_vm_apagada.png)

**Figura 250.** VM apagada correctamente antes de exportar.

![Exportación de la VM a OVA completada.](../capturas/ova-exportacion/OVA_04_exportacion.png)

**Figura 251.** Exportación de la VM a OVA completada.

![Tamaño del archivo OVA generado.](../capturas/ova-exportacion/OVA_05_tamano.png)

**Figura 252.** Tamaño del archivo OVA generado.

![Contenido del OVA: descriptor OVF, disco VMDK y manifiesto.](../capturas/ova-exportacion/OVA_06_contenido.png)

**Figura 253.** Contenido del OVA: descriptor OVF, disco VMDK y manifiesto.

![Generación del checksum SHA-256.](../capturas/ova-exportacion/OVA_07_sha256_generado.png)

**Figura 254.** Generación del checksum SHA-256.

![Verificación del checksum SHA-256.](../capturas/ova-exportacion/OVA_08_sha256_verificado.png)

**Figura 255.** Verificación del checksum SHA-256.

![Simulación de importación con `--dry-run`.](../capturas/ova-exportacion/OVA_09_dry_run.png)

**Figura 256.** Simulación de importación con `--dry-run`.

![Comprobación de que el nombre de la copia está libre.](../capturas/ova-exportacion/OVA_10_nombre_libre.png)

**Figura 257.** Comprobación de que el nombre de la copia está libre.

![Importación de la OVA como copia independiente.](../capturas/ova-exportacion/OVA_11_importacion.png)

**Figura 258.** Importación de la OVA como copia independiente.

![Copia registrada en VirtualBox.](../capturas/ova-exportacion/OVA_12_copia_registrada.png)

**Figura 259.** Copia registrada en VirtualBox.

![Dirección MAC regenerada para evitar conflictos.](../capturas/ova-exportacion/OVA_13_mac_regenerada.png)

**Figura 260.** Dirección MAC regenerada para evitar conflictos.

![Reenvíos NAT de la copia importada.](../capturas/ova-exportacion/OVA_14_nat_copia.png)

**Figura 261.** Reenvíos NAT de la copia importada.

![Copia encendida correctamente.](../capturas/ova-exportacion/OVA_15_copia_arrancada.png)

**Figura 262.** Copia encendida correctamente.

![Contenedores activos dentro de la copia.](../capturas/ova-exportacion/OVA_16_contenedores_copia.png)

**Figura 263.** Contenedores activos dentro de la copia.

![Servicios del proyecto funcionando en la copia.](../capturas/ova-exportacion/OVA_17_servicios_copia.png)

**Figura 264.** Servicios del proyecto funcionando en la copia.

![Cuatro puertos con HTTP 200 dentro de la copia.](../capturas/ova-exportacion/OVA_18_http_copia.png)

**Figura 265.** Cuatro puertos con HTTP 200 dentro de la copia.

![Verificación integral de la copia importada.](../capturas/ova-exportacion/OVA_19_verificacion_copia.png)

**Figura 266.** Verificación integral de la copia importada.

![Confirmación de los cuatro puertos en la copia.](../capturas/ova-exportacion/OVA_20_http_copia_confirmado.png)

**Figura 267.** Confirmación de los cuatro puertos en la copia.

![Cuatro puertos con HTTP 200 desde el host.](../capturas/ova-exportacion/OVA_20_http_desde_host.png)

**Figura 268.** Cuatro puertos con HTTP 200 desde el host.

![Checksum SHA-256 de la OVA final.](../capturas/ova-exportacion/proyecto-isl135-grupo7.ova.sha256)

**Figura 269.** Checksum SHA-256 de la OVA final.

### Conclusión de la fase

La OVA final se exportó, se verificó con SHA-256 y se importó como una copia
independiente. Los cuatro servicios respondieron `HTTP 200` tanto dentro de la
copia como desde el host.


# Resultados

| Servicio | Puerto | Estado | Evidencia |
|---|---|---|---|
| Nginx básico con bind mount | 8080 | HTTP 200 | `capturas/fase-05-nginx-basico/` |
| Imagen personalizada | 8081 | HTTP 200 | `capturas/fase-06-imagen-personalizada/` |
| Red personalizada | 8082 | HTTP 200 | `capturas/fase-07-redes-volumenes/` |
| Volumen persistente | 8083 | HTTP 200 | `capturas/fase-07-redes-volumenes/` |
| Verificación integral | 8080–8083 | Aprobada | `capturas/fase-08-pruebas-verificacion/` |

Los cuatro contenedores quedaron activos, cron se ejecuta cada 30 minutos, el
repositorio está limpio y los servicios vuelven a arrancar después de reiniciar
la máquina virtual.

# Dificultades y soluciones

1. **Repositorio Docker para Debian Trixie:** la URL inicial devolvía 404. Se
   corrigió la suite a `trixie` y se validó la clave GPG antes de instalar.
2. **Snapshot de la fase 5 perdido:** VirtualBox perdió el registro histórico. Se
   creó el punto consolidado `05-nginx-recuperado` y se continuó sin bloquear la
   fase 6.
3. **Cambios pendientes en Git durante la verificación:** el verificador detectó
   archivos sin commit. Se prepararon, se commitearon y se volvió a ejecutar la
   verificación hasta obtener código 0.

# Conclusiones

- El servidor quedó funcionando con cuatro servicios web en Docker.
- La automatización con cron registra el estado del sistema cada 30 minutos.
- Git permitió el trabajo colaborativo y la trazabilidad de cada fase.
- Docker facilitó la reproducción del entorno y la separación de técnicas:
  bind mount, imagen propia, red personalizada y volumen persistente.
- La OVA se exportó, se verificó con SHA-256 y se importó como copia
  independiente, demostrando portabilidad.

# Recomendaciones y trabajo futuro

- Usar `docker compose` para declarar los cuatro servicios en un solo archivo.
- Fijar versiones de imágenes en lugar de `latest`.
- Implementar HTTPS con Let's Encrypt.
- Usar un usuario no root dentro de los contenedores.
- Gestionar secretos con Docker secrets o un gestor externo.
- Agregar respaldos del volumen y monitoreo con Prometheus/Grafana.
- Automatizar la verificación con CI/CD.

# Bibliografía

- Debian Project. *Debian GNU/Linux Documentation*. https://www.debian.org/doc/
- Docker Inc. *Docker Documentation*. https://docs.docker.com/
- Nginx. *Nginx Documentation*. https://nginx.org/en/docs/
- Git. *Pro Git*. https://git-scm.com/book/es/v2
- GitHub. *GitHub Docs*. https://docs.github.com/
- Universidad de El Salvador. *Guía del Proyecto Final ISL135*, Ciclo II 2026.

# Anexos

## Anexo A — Script de monitoreo

```bash

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

```

## Anexo B — Dockerfile

```dockerfile

FROM nginx:latest

LABEL maintainer="Grupo 7 - ISL135"
LABEL description="Servidor web personalizado del proyecto final"

# Copia el sitio dentro de la imagen
COPY web/ /usr/share/nginx/html/

# Documenta el puerto que expone Nginx
EXPOSE 80

# Mantiene Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]

```

## Anexo C — Script de verificación integral

```bash

#!/usr/bin/env bash
#
# verificar_proyecto.sh - Verificación integral del proyecto ISL135
# Ejecutar como adminsys (con acceso a Docker) desde la VM:
#   /proyecto/scripts/verificar_proyecto.sh
#
# Devuelve 0 si todas las comprobaciones obligatorias pasan y 1 si hay fallos.
# No modifica el sistema ni los contenedores.
#
set -u

VERDE=$'\033[0;32m'
ROJO=$'\033[0;31m'
AMARILLO=$'\033[1;33m'
NC=$'\033[0m'

fallos=0
avisos=0

ok()    { printf '%s[OK]%s %s\n'    "$VERDE"    "$NC" "$*"; }
fallo() { printf '%s[FALLO]%s %s\n' "$ROJO"     "$NC" "$*"; fallos=$((fallos + 1)); }
aviso() { printf '%s[AVISO]%s %s\n' "$AMARILLO" "$NC" "$*"; avisos=$((avisos + 1)); }
info()  { printf '%s[INFO]%s %s\n'  "$AMARILLO" "$NC" "$*"; }

echo "=================================================="
echo " VERIFICACIÓN INTEGRAL - PROYECTO ISL135"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo " Host:  $(hostname)"
echo " Usuario: $(id -un)"
echo "=================================================="

if [[ "$(id -un)" != "adminsys" ]]; then
    aviso "Ejecuta como adminsys para comprobar Docker sin sudo; usuario actual: $(id -un)"
fi

# 1. Hostname
if [[ "$(hostname)" =~ ^servidor-grupo[0-9]+$ ]]; then
    ok "Hostname correcto: $(hostname)"
else
    fallo "Hostname inesperado: $(hostname) (se esperaba servidor-grupoN)"
fi

# 2. Usuarios y grupos
for u in adminsys tecnico visitante; do
    if id "$u" >/dev/null 2>&1; then
        ok "Existe el usuario $u"
    else
        fallo "Falta el usuario $u"
    fi
done

id -nG adminsys  2>/dev/null | grep -qw sudo    && ok "adminsys pertenece a sudo"    || fallo "adminsys no pertenece a sudo"
id -nG tecnico   2>/dev/null | grep -qw soporte && ok "tecnico pertenece a soporte"  || fallo "tecnico no pertenece a soporte"
id -nG visitante 2>/dev/null | grep -qw web     && ok "visitante pertenece a web"    || fallo "visitante no pertenece a web"

for u in adminsys tecnico; do
    id -nG "$u" 2>/dev/null | grep -qw docker \
        && ok "$u pertenece al grupo docker" \
        || fallo "$u no pertenece al grupo docker"
done

# 3. Directorios, grupo propietario y setgid
for d in datos web scripts capturas; do
    if [[ -d "/proyecto/$d" ]]; then
        ok "Existe /proyecto/$d"
    else
        fallo "Falta /proyecto/$d"
    fi
done

if [[ -w /proyecto ]]; then
    ok "El usuario actual puede escribir en /proyecto"
else
    fallo "El usuario actual no puede escribir en /proyecto"
fi

grupo_datos="$(stat -c '%G' /proyecto/datos 2>/dev/null || true)"
grupo_web="$(stat -c '%G' /proyecto/web 2>/dev/null || true)"
perm_datos="$(stat -c '%A' /proyecto/datos 2>/dev/null || true)"
perm_web="$(stat -c '%A' /proyecto/web 2>/dev/null || true)"

[[ "$grupo_datos" == "soporte" ]] && ok "datos: grupo soporte" || fallo "datos: grupo incorrecto ($grupo_datos)"
[[ "$grupo_web" == "web" ]]       && ok "web: grupo web"       || fallo "web: grupo incorrecto ($grupo_web)"
[[ "$perm_datos" == drwxrws* ]]   && ok "datos tiene setgid ($perm_datos)" || fallo "datos sin setgid ($perm_datos)"
[[ "$perm_web" == drwxrws* ]]     && ok "web tiene setgid ($perm_web)"     || fallo "web sin setgid ($perm_web)"

if [[ -f /proyecto/web/index.html ]]; then
    ok "Existe /proyecto/web/index.html"
else
    fallo "Falta /proyecto/web/index.html"
fi

if [[ -f /proyecto/Dockerfile ]]; then
    ok "Existe /proyecto/Dockerfile"
else
    fallo "Falta /proyecto/Dockerfile"
fi

# 4. Script de monitoreo
if [[ -x /proyecto/scripts/reporte_sistema.sh ]]; then
    ok "reporte_sistema.sh es ejecutable"

    salida_reporte="$(/proyecto/scripts/reporte_sistema.sh 2>&1)" || true
    for etiqueta in "REPORTE DEL SISTEMA" "Hostname" "Usuarios conectados" "Disco principal" "RAM disponible" "Contenedores Docker"; do
        if grep -Fq "$etiqueta" <<<"$salida_reporte"; then
            ok "El reporte contiene: $etiqueta"
        else
            fallo "El reporte no contiene: $etiqueta"
        fi
    done
else
    fallo "reporte_sistema.sh no existe o no es ejecutable"
fi

# 5. Cron y log
if [[ -f /etc/cron.d/proyecto ]]; then
    ok "Existe /etc/cron.d/proyecto"
    if grep -Eq '^[^#]*\*/30[[:space:]].*reporte_sistema\.sh' /etc/cron.d/proyecto; then
        ok "Cron programado cada 30 minutos"
    else
        fallo "Cron no contiene una entrada */30 para reporte_sistema.sh"
    fi
else
    fallo "Falta /etc/cron.d/proyecto"
fi

systemctl is-active --quiet cron && ok "Servicio cron activo" || fallo "Servicio cron inactivo"
systemctl is-enabled --quiet cron && ok "Servicio cron habilitado" || fallo "Servicio cron no habilitado"

log_cron="/var/log/proyecto/reporte_sistema.log"
if [[ -s "$log_cron" ]]; then
    ok "Log de cron con contenido ($(wc -l < "$log_cron") líneas)"
    if find "$log_cron" -mmin -35 -print -quit 2>/dev/null | grep -q .; then
        ok "Log actualizado en los últimos 35 minutos"
    else
        aviso "El log no se ha actualizado en los últimos 35 minutos"
    fi
else
    fallo "Log de cron vacío o ausente: $log_cron"
fi

# 6. Docker
if command -v docker >/dev/null 2>&1; then
    ok "Docker instalado: $(docker --version 2>/dev/null)"
    systemctl is-active --quiet docker && ok "Servicio docker activo" || fallo "Servicio docker inactivo"
    systemctl is-enabled --quiet docker && ok "Servicio docker habilitado" || fallo "Servicio docker no habilitado"

    if docker info >/dev/null 2>&1; then
        ok "El usuario actual puede usar Docker"

        if docker images --format '{{.Repository}}' | grep -Eq '^servidor-grupo[0-9]+$'; then
            ok "Existe una imagen servidor-grupoN"
        else
            fallo "No existe la imagen servidor-grupoN"
        fi
    else
        fallo "Sin acceso a Docker (revisa el grupo docker y vuelve a iniciar sesión)"
    fi
else
    fallo "Docker no está instalado"
fi

# 7. Contenedores, puertos, red y volumen
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    for c in nginx-basico nginx-personalizado nginx-red nginx-volumen; do
        if docker ps --format '{{.Names}}' | grep -qx "$c"; then
            ok "Contenedor activo: $c"
        else
            fallo "Contenedor no activo: $c"
        fi
    done

    mount_basico="$(docker inspect -f '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' nginx-basico 2>/dev/null || true)"
    mount_red="$(docker inspect -f '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' nginx-red 2>/dev/null || true)"
    mount_volumen="$(docker inspect -f '{{range .Mounts}}{{.Name}} -> {{.Destination}}{{"\n"}}{{end}}' nginx-volumen 2>/dev/null || true)"

    grep -Fq '/proyecto/web -> /usr/share/nginx/html' <<<"$mount_basico" \
        && ok "nginx-basico monta /proyecto/web" \
        || fallo "nginx-basico no monta /proyecto/web"
    grep -Fq '/proyecto/web -> /usr/share/nginx/html' <<<"$mount_red" \
        && ok "nginx-red monta /proyecto/web" \
        || aviso "nginx-red no monta /proyecto/web (no es obligatorio para la fase 7)"
    grep -Fq 'volumen-web -> /usr/share/nginx/html' <<<"$mount_volumen" \
        && ok "nginx-volumen usa volumen-web" \
        || fallo "nginx-volumen no usa volumen-web"

    for p in 8080 8081 8082 8083; do
        code="$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://localhost:$p" 2>/dev/null || echo '000')"
        [[ "$code" == "200" ]] && ok "http://localhost:$p -> 200" || fallo "http://localhost:$p -> $code"
    done

    docker network inspect red-proyecto >/dev/null 2>&1 \
        && ok "Red red-proyecto existe" \
        || fallo "Falta red red-proyecto"

    if docker inspect -f '{{json .NetworkSettings.Networks}}' nginx-red 2>/dev/null | grep -q 'red-proyecto'; then
        ok "nginx-red está conectado a red-proyecto"
    else
        fallo "nginx-red no está conectado a red-proyecto"
    fi

    docker volume inspect volumen-web >/dev/null 2>&1 \
        && ok "Volumen volumen-web existe" \
        || fallo "Falta volumen volumen-web"

    if docker exec nginx-volumen test -s /usr/share/nginx/html/index.html >/dev/null 2>&1; then
        ok "El volumen contiene index.html"
    else
        fallo "El volumen no contiene index.html"
    fi
fi

# 8. Git
if [[ -d /proyecto/.git ]]; then
    ok "Repositorio Git en /proyecto"

    if git -C /proyecto remote get-url origin >/dev/null 2>&1; then
        ok "Remoto origin: $(git -C /proyecto remote get-url origin)"
    else
        fallo "Sin remoto origin"
    fi

    if [[ -f /proyecto/README.md ]]; then
        ok "Existe README.md"
    else
        fallo "Falta README.md"
    fi

    if [[ -f /proyecto/.gitignore ]]; then
        ok "Existe .gitignore"
    else
        fallo "Falta .gitignore"
    fi

    estado_git="$(git -C /proyecto status --porcelain 2>/dev/null || true)"
    if [[ -z "$estado_git" ]]; then
        ok "Git sin cambios pendientes"
    else
        fallo "Git tiene cambios sin commitear"
        printf '%s\n' "$estado_git"
    fi

    autores="$(git -C /proyecto log --format='%an' 2>/dev/null | sed '/^$/d' | sort -u | wc -l)"
    if (( autores >= 4 )); then
        ok "Commits de $autores autores distintos"
    else
        fallo "Solo $autores autores distintos; se esperan al menos 4"
    fi

    if git -C /proyecto ls-files | grep -Eq '\.(ova|vdi|iso)$'; then
        fallo "El repositorio contiene una imagen de VM (OVA/VDI/ISO)"
    else
        ok "El repositorio no contiene OVA/VDI/ISO"
    fi

    info "Últimos commits:"
    git -C /proyecto log --oneline -5 2>/dev/null || true
else
    fallo "No hay repositorio Git en /proyecto"
fi

echo "=================================================="
if (( fallos == 0 )); then
    if (( avisos > 0 )); then
        printf '%sRESULTADO: todo lo obligatorio pasó, con %d aviso(s).%s\n' "$VERDE" "$avisos" "$NC"
    else
        printf '%sRESULTADO: todas las verificaciones pasaron.%s\n' "$VERDE" "$NC"
    fi
    exit 0
else
    printf '%sRESULTADO: %d verificación(es) con fallo.%s\n' "$ROJO" "$fallos" "$NC"
    exit 1
fi

```

## Anexo D — Repositorio

- GitHub: https://github.com/cecv9/proyecto-linux-grupo7
- README: [`README.md`](../README.md)
- Evidencias: [`capturas/INDICE.md`](../capturas/INDICE.md)
- Documentación oficial: [`docs/README.md`](README.md)
