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

## Estructura del repositorio

```text
/proyecto/
├── datos/                  # Archivos de configuración
├── web/                    # Sitio servido por Nginx
├── scripts/                # Automatización y verificación
├── capturas/               # Evidencias de las fases
├── Dockerfile              # Imagen personalizada
├── .dockerignore
├── .gitignore
└── README.md
```

## Requisitos

- VirtualBox 7.2 o compatible
- Debian 13
- Git
- Docker Engine
- Acceso a los puertos `8080` a `8083`

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

## Scripts y automatización

`scripts/reporte_sistema.sh` muestra fecha, hostname, usuarios conectados,
espacio en disco, memoria RAM y cantidad de contenedores activos.

La tarea `/etc/cron.d/proyecto` lo ejecuta cada 30 minutos y registra la salida
en `/var/log/proyecto/reporte_sistema.log`.

## Evidencias

Las capturas de las fases están documentadas en `capturas/INDICE.md` y
respaldadas dentro de la máquina virtual en `/proyecto/capturas/`.

## Seguridad

El repositorio no contiene contraseñas, tokens ni claves privadas. El acceso a
GitHub se realiza mediante una clave SSH, y el grupo `docker` se limita al
entorno académico de laboratorio.

## Licencia

Proyecto académico de la Universidad de El Salvador, ciclo II de 2026.
