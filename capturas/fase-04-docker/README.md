# Fase 04 — Instalación y configuración de Docker

## Objetivo

Instalar Docker Engine, habilitarlo y permitir su uso sin `sudo` a los usuarios autorizados.

## Qué se hizo

Se instaló Docker desde el repositorio oficial, se habilitó e inició el servicio, se agregaron `adminsys` y `tecnico` al grupo `docker`, se aplicó el cambio con `newgrp docker` y se ejecutó la prueba oficial `hello-world`. Finalmente se listaron imágenes y contenedores.

## Comandos principales

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

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F04_00_prevalidacion.png`](F04_00_prevalidacion.png) | Comprobación previa. |
| [`F04_00_prevalidacion.txt`](F04_00_prevalidacion.txt) | Comprobación previa. |
| [`F04_00_prevalidacion_01_sesion_so.png`](F04_00_prevalidacion_01_sesion_so.png) | Comprobación previa: sesión del sistema operativo. |
| [`F04_00_prevalidacion_02_git_fetch.png`](F04_00_prevalidacion_02_git_fetch.png) | Comprobación previa: git fetch. |
| [`F04_00_prevalidacion_03_git_limpio.png`](F04_00_prevalidacion_03_git_limpio.png) | Comprobación previa: repositorio Git limpio. |
| [`F04_00_prevalidacion_04_docker_ausente.png`](F04_00_prevalidacion_04_docker_ausente.png) | Comprobación previa: Docker no instalado. |
| [`F04_00_prevalidacion_05_sin_repositorio_docker.png`](F04_00_prevalidacion_05_sin_repositorio_docker.png) | Comprobación previa: repositorio Docker ausente. |
| [`F04_00_prevalidacion_06_espacio.png`](F04_00_prevalidacion_06_espacio.png) | Comprobación previa: espacio disponible en disco. |
| [`F04_00_prevalidacion_07_docker_trixie_404.png`](F04_00_prevalidacion_07_docker_trixie_404.png) | Comprobación previa: repositorio Docker para Trixie devuelve 404. |
| [`F04_00_prevalidacion_08_docker_suites.png`](F04_00_prevalidacion_08_docker_suites.png) | Comprobación previa: suites del repositorio Docker. |
| [`F04_00_prevalidacion_09_docker_trixie_contenido.png`](F04_00_prevalidacion_09_docker_trixie_contenido.png) | Comprobación previa: contenido del repositorio Trixie. |
| [`F04_00_prevalidacion_10_docker_trixie_200.png`](F04_00_prevalidacion_10_docker_trixie_200.png) | Comprobación previa: repositorio Docker para Trixie responde 200. |
| [`F04_01_apt_install_docker.txt`](F04_01_apt_install_docker.txt) | Instalación de Docker con apt. |
| [`F04_01_apt_update.png`](F04_01_apt_update.png) | Actualización de paquetes con apt. |
| [`F04_01_apt_update_docker.png`](F04_01_apt_update_docker.png) | Actualización del repositorio de Docker. |
| [`F04_01_descarga_clave.png`](F04_01_descarga_clave.png) | Descarga de la clave GPG de Docker. |
| [`F04_01_docker_active.png`](F04_01_docker_active.png) | Servicio Docker activo. |
| [`F04_01_docker_enable.png`](F04_01_docker_enable.png) | Docker habilitado al inicio. |
| [`F04_01_docker_info.png`](F04_01_docker_info.png) | Salida de docker info con cliente y servidor. |
| [`F04_01_docker_info_detail.png`](F04_01_docker_info_detail.png) | Información de Docker (detalle). |
| [`F04_01_docker_info_detail_recorte.png`](F04_01_docker_info_detail_recorte.png) | Información de Docker (detalle, recorte). |
| [`F04_01_docker_version.png`](F04_01_docker_version.png) | Versión de Docker. |
| [`F04_01_fuente_docker_creada.png`](F04_01_fuente_docker_creada.png) | Fuente de Docker creada. |
| [`F04_01_fuente_docker_verificada.png`](F04_01_fuente_docker_verificada.png) | Fuente de Docker verificada. |
| [`F04_01_instalacion.txt`](F04_01_instalacion.txt) | Instalación. |
| [`F04_01_keyrings.png`](F04_01_keyrings.png) | Directorio de keyrings. |
| [`F04_01_permiso_clave.png`](F04_01_permiso_clave.png) | Permisos de la clave GPG. |
| [`F04_01_prerequisitos.png`](F04_01_prerequisitos.png) | Prerrequisitos instalados. |
| [`F04_02_adminsys_sin_sudo.png`](F04_02_adminsys_sin_sudo.png) | Adminsys usando Docker sin sudo. |
| [`F04_02_getent_group_docker.png`](F04_02_getent_group_docker.png) | Consulta del grupo docker con getent. |
| [`F04_02_grupo_docker.png`](F04_02_grupo_docker.png) | Grupo docker. |
| [`F04_02_grupo_docker.txt`](F04_02_grupo_docker.txt) | Grupo docker. |
| [`F04_02_id_adminsys.png`](F04_02_id_adminsys.png) | ID y grupos de adminsys. |
| [`F04_02_id_tecnico.png`](F04_02_id_tecnico.png) | ID y grupos de tecnico. |
| [`F04_02_id_tecnico_recorte.png`](F04_02_id_tecnico_recorte.png) | ID y grupos de tecnico recorte. |
| [`F04_02_newgrp_docker.png`](F04_02_newgrp_docker.png) | Nueva sesión con el grupo docker. |
| [`F04_02_tecnico_sin_sudo.png`](F04_02_tecnico_sin_sudo.png) | Tecnico usando Docker sin sudo. |
| [`F04_02_usermod_adminsys.png`](F04_02_usermod_adminsys.png) | Adminsys agregado al grupo docker. |
| [`F04_02_usermod_tecnico.png`](F04_02_usermod_tecnico.png) | Tecnico agregado al grupo docker. |
| [`F04_03_docker_images.png`](F04_03_docker_images.png) | Imágenes Docker disponibles. |
| [`F04_03_docker_ps_a.png`](F04_03_docker_ps_a.png) | Contenedores con docker ps -a. |
| [`F04_03_hello_world.png`](F04_03_hello_world.png) | Prueba oficial hello-world de Docker. |
| [`F04_03_hello_world.txt`](F04_03_hello_world.txt) | Prueba hello-world. |
| [`F04_03_hello_world_01_ejecucion.png`](F04_03_hello_world_01_ejecucion.png) | Ejecución de la prueba hello-world. |
| [`F04_04_commit.png`](F04_04_commit.png) | Commit de evidencias de la fase 4. |
| [`F04_04_evidencias_en_vm.png`](F04_04_evidencias_en_vm.png) | Evidencias dentro de la VM. |
| [`F04_04_git_add.png`](F04_04_git_add.png) | Preparación de evidencias con git add. |
| [`F04_04_git_diff_cached.png`](F04_04_git_diff_cached.png) | Revisión de cambios preparados con git diff --cached. |
| [`F04_04_snapshot.png`](F04_04_snapshot.png) | Snapshot. |
| [`F04_04_snapshot.txt`](F04_04_snapshot.txt) | Snapshot. |
| [`F04_04_verificacion_nombres_fallida.png`](F04_04_verificacion_nombres_fallida.png) | Verificación de nombres fallida. |

## Resultado

Docker funciona y los usuarios del grupo `docker` pueden administrarlo sin `sudo`.
