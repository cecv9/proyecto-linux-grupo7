# Fase 4 — Docker y `hello-world`

> Proyecto Final ISL135 · Grupo 7 · VM `Debian 13`
>
> Ejecuta los bloques en orden y detente si una comprobación no coincide. Las
> capturas definitivas se guardan en `/proyecto/capturas/` y se respaldan en
> `revision-proyecto-isl135/evidencias/F04/`.

## Estado de esta guía

- [x] Punto de control 1: prevalidación del sistema y conectividad
- [x] Punto de control 2: instalar Docker desde el repositorio oficial
- [x] Punto de control 3: habilitar Docker y verificar versión e información
- [x] Punto de control 4: agregar `adminsys` y `tecnico` al grupo `docker`
- [x] Punto de control 5: ejecutar y verificar `hello-world`
- [x] Punto de control 6: commit de cambios, evidencias y snapshot `04-docker`

## Evidencias previstas

| Archivo | Contenido |
|---|---|
| `F04_00_prevalidacion.png` | Debian 13,`trixie`, arquitectura, Git limpio y ausencia de Docker |
| `F04_01_docker_info.png` | Instalación, servicio activo, `docker version` y `docker info` |
| `F04_02_grupo_docker.png` | `adminsys` y `tecnico` dentro del grupo `docker` |
| `F04_03_hello_world.png` | Salida de `hello-world`, `docker ps -a` e imágenes |
| `F04_04_snapshot.png` | Snapshot `04-docker` creado y verificado |

## Punto de control 1 — Prevalidación sin instalar paquetes

Confirma que la sesión SSH está conectada a la VM y que trabajas como
`adminsys`:

```bash
hostname
whoami
```

Resultado esperado:

```text
servidor-grupo7
adminsys
```

Revisa la versión y el nombre clave de Debian:

```bash
. /etc/os-release
printf 'Distribución: %s\nVersión: %s\nClave: %s\n' "$PRETTY_NAME" "$VERSION_ID" "$VERSION_CODENAME"
```

Comprueba la arquitectura:

```bash
dpkg --print-architecture
```

Debe devolver `amd64`.

Comprueba que el repositorio está limpio y actualizado:

```bash
cd /proyecto
git fetch --prune
git status --short --branch
```

Debe mostrar `## main...origin/main` sin cambios.

Comprueba si Docker ya está instalado:

```bash
if command -v docker >/dev/null 2>&1; then
    docker --version
else
    echo "Docker no está instalado"
fi
```

Comprueba si ya existe un repositorio de Docker configurado:

```bash
grep -RhsE '^deb .*docker' /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null || echo "Sin repositorio Docker configurado"
```

Comprueba espacio disponible antes de descargar imágenes:

```bash
df -h / /var/lib
```

Comprueba la conectividad con el repositorio oficial:

```bash
curl -fsSI https://download.docker.com/linux/debian/dists/trixie/Release | head -n 1
```

Resultado esperado: una respuesta que comienza con `HTTP/` y código `200` o
`302`.

> La ruta correcta del archivo de release es `dists/trixie/Release`. La fuente
> APT usa `trixie` como suite y `stable` como componente; no se debe añadir
> `stable/Release` a la ruta.

## Evidencia `F04_00_prevalidacion.png`

Toma una captura donde aparezcan:

- hostname y usuario;
- Debian `13`, `trixie` y arquitectura `amd64`;
- estado limpio del repositorio Git;
- resultado de la comprobación de Docker;
- espacio disponible;
- respuesta HTTP del repositorio oficial.

Guarda la copia inicial en el host como:

```text
/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/evidencias/F04/F04_00_prevalidacion.png
```

## Cierre del primer bloque

No ejecutes todavía la instalación si:

- el hostname no es `servidor-grupo7`;
- `whoami` no es `adminsys`;
- Debian no es la versión `13`/`trixie`;
- Git no está limpio;
- Docker ya aparece instalado;
- la conexión al repositorio oficial falla.

