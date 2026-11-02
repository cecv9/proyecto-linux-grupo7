# proyecto-linux-grupo7

Servidor Linux automatizado con Debian 13, Bash, cron, Git, Docker y Nginx para
el **Proyecto Final de Introducción al Software Libre (ISL135)**.

## Integrantes

| Integrante | Nombre                             | Usuario de GitHub                                    | Aporte principal                                  |
| ---------- | ---------------------------------- | ---------------------------------------------------- | ------------------------------------------------- |
| 1          | Carlos Enoc Calzada Vargas         | [@cecv9](https://github.com/cecv9)                   | Coordinación, entorno Linux y documentación final |
| 2          | Azucena del Carmen Castillo Zepeda | [@cz08008-zuz](https://github.com/cz08008-zuz)       | Automatización y control de versiones.            |
| 3          | Ronie Odir Portillo Consuegra      | [@pc15016-Ronnie](https://github.com/pc15016-Ronnie) | Docker y servidor web base                        |
| 4 | Josué Daniel Cruz Arce | [@DanielCruz98-503](https://github.com/DanielCruz98-503) | Imagen personalizada, redes, volúmenes y pruebas |

## Descripción

El proyecto implementa una máquina virtual Debian 13 con servicios web Nginx
ejecutados mediante Docker, un reporte del sistema automatizado con cron y un
repositorio Git versionado en GitHub.

## Tecnologías

- Debian 13
- Bash
- cron
- Git y GitHub
- Docker Engine
- Nginx
- HTML

## Arquitectura y puertos

| Puerto | Contenedor | Técnica demostrada |
|---|---|---|
| `8080` | `nginx-basico` | Sitio con bind mount de `/proyecto/web` |
| `8081` | `nginx-personalizado` | Imagen propia construida mediante `Dockerfile` |
| `8082` | `nginx-red` | Contenedor conectado a `red-proyecto` |
| `8083` | `nginx-volumen` | Contenido persistente en `volumen-web` |

## Fases del proyecto

| Fase | Tema | Evidencias |
|---|---|---|
| 00 | Preparación del entorno | [`capturas/fase-00-preparacion`](capturas/fase-00-preparacion/README.md) |
| 01 | Administración básica, usuarios y permisos | [`capturas/fase-01-administracion-basica`](capturas/fase-01-administracion-basica/README.md) |
| 02 | Automatización y monitoreo | [`capturas/fase-02-automatizacion-monitoreo`](capturas/fase-02-automatizacion-monitoreo/README.md) |
| 03 | Control de versiones y GitHub | [`capturas/fase-03-control-versiones`](capturas/fase-03-control-versiones/README.md) |
| 04 | Instalación y configuración de Docker | [`capturas/fase-04-docker`](capturas/fase-04-docker/README.md) |
| 05 | Servidor web Nginx básico | [`capturas/fase-05-nginx-basico`](capturas/fase-05-nginx-basico/README.md) |
| 06 | Imagen personalizada con Dockerfile | [`capturas/fase-06-imagen-personalizada`](capturas/fase-06-imagen-personalizada/README.md) |
| 07 | Redes y volúmenes de Docker | [`capturas/fase-07-redes-volumenes`](capturas/fase-07-redes-volumenes/README.md) |
| 08 | Pruebas y verificación final | [`capturas/fase-08-pruebas-verificacion`](capturas/fase-08-pruebas-verificacion/README.md) |

## Estructura del repositorio

```text
/proyecto/
├── datos/                  # Archivos de configuración
│   └── aportes/            # Aportes individuales de los integrantes
├── web/                    # Sitio servido por Nginx
├── scripts/                # Automatización y verificación
├── capturas/               # Evidencias organizadas por fase
│   ├── INDICE.md           # Índice general de evidencias
│   ├── fase-00-preparacion/
│   ├── fase-01-administracion-basica/
│   ├── fase-02-automatizacion-monitoreo/
│   ├── fase-03-control-versiones/
│   ├── fase-04-docker/
│   ├── fase-05-nginx-basico/
│   ├── fase-06-imagen-personalizada/
│   ├── fase-07-redes-volumenes/
│   └── fase-08-pruebas-verificacion/
├── Dockerfile              # Imagen personalizada
├── .dockerignore
├── .gitignore
└── README.md
```

Cada carpeta de fase contiene sus imágenes y un `README.md` con el objetivo, los comandos principales y la descripción breve de cada evidencia. El índice general está en [`capturas/INDICE.md`](capturas/INDICE.md).

## Requisitos

- VirtualBox 7.2 o compatible
- Debian 13
- Git
- Docker Engine
- Acceso a los puertos `8080` a `8083`

## Máquina virtual

- Nombre de la VM en VirtualBox: `Debian 13`.
- Hostname interno: `servidor-grupo7`.
- Acceso SSH: `ssh -p 2222 adminsys@127.0.0.1`.
- Puertos publicados: `8080`, `8081`, `8082` y `8083`.

Si la VM se importa con otro nombre, cambia `Debian 13` por el nombre que muestre
`VBoxManage list vms`. La guía paso a paso está en [`GUIA_VM.md`](GUIA_VM.md).

## Instalación

1. Crear y actualizar la máquina virtual Debian 13.
2. Configurar hostname, usuarios, grupos, directorios y permisos.
3. Instalar y programar `scripts/reporte_sistema.sh` con cron.
4. Inicializar el repositorio Git y enlazarlo con GitHub.
5. Instalar Docker y ejecutar el contenedor de prueba `hello-world`.
6. Crear los cuatro servicios Nginx de las fases 5 a 7.
7. Ejecutar `scripts/verificar_proyecto.sh` y comprobar los puertos.

## Uso y verificación

```bash
docker ps
curl -I http://localhost:8080
curl -I http://localhost:8081
curl -I http://localhost:8082
curl -I http://localhost:8083
```

Cada puerto debe responder `HTTP/1.1 200 OK`.

### Demo rápida

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
for p in 8080 8081 8082 8083; do
  curl -s -o /dev/null -w "$p -> %{http_code}\n" "http://localhost:$p"
done
/proyecto/scripts/verificar_proyecto.sh
```

## Scripts y automatización

`scripts/reporte_sistema.sh` muestra fecha, hostname, usuarios conectados,
espacio en disco, memoria RAM y cantidad de contenedores activos.

La tarea `/etc/cron.d/proyecto` lo ejecuta cada 30 minutos y registra la salida
en `/var/log/proyecto/reporte_sistema.log`.

## Evidencias

Las capturas están organizadas por fase en `capturas/`. El índice general está en
[`capturas/INDICE.md`](capturas/INDICE.md). Cada carpeta incluye un `README.md`
con el objetivo de la fase, los comandos principales y la descripción breve de
cada imagen. Las evidencias también están respaldadas dentro de la máquina
virtual en `/proyecto/capturas/`.

## Documentación

- [`GUIA_VM.md`](GUIA_VM.md): cómo importar, encender y verificar la máquina virtual.
- [`GUIA_INFORME.md`](GUIA_INFORME.md): cómo ordenar el informe y exportarlo a PDF.
- [`capturas/INDICE.md`](capturas/INDICE.md): índice general de evidencias por fase.

## Seguridad

El repositorio no contiene contraseñas, tokens ni claves privadas. El acceso a
GitHub se realiza mediante una clave SSH, y el grupo `docker` se limita al
entorno académico de laboratorio.

## Licencia

Proyecto académico de la Universidad de El Salvador, ciclo II de 2026.
