# Proyecto Final ISL135 — Servidor Linux automatizado con Docker

> **Nota para el Grupo 7:** algunos ejemplos de esta documentación usan el Grupo 1
> como modelo. En este repositorio el hostname es `servidor-grupo7`, la imagen es
> `servidor-grupo7` y el repositorio es `cecv9/proyecto-linux-grupo7`.

Material de trabajo para el proyecto de **Introducción al Software Libre (Ciclo II–2026)**:
análisis del enunciado, guía paso a paso, creación/exportación de la VM, informe,
presentación y checklist de entrega.

> **Entrega:** martes **03 de noviembre de 2026** · **Defensas:** semanas 13 y 14 · **Grupos:** 4 integrantes.

---

## Qué contiene esta carpeta

| Archivo | Para qué sirve |
|---|---|
| `00_ANALISIS_Y_PLAN.md` | Lectura del enunciado, matriz de requisitos, arquitectura, decisiones de diseño, roles y cronograma. **Empieza aquí.** |
| `01_GUIA_PASO_A_PASO.md` | Comandos exactos, fase por fase (0 a 8), con verificación, evidencia y solución de problemas. Es el documento de trabajo principal. |
| `02_VM_EXPORTAR_IMPORTAR.md` | Crear la VM en VirtualBox 7.2, snapshots, exportar a `.ova` e importar en las computadoras de los otros integrantes. |
| `FASE_8_COMANDOS.md` | Registro reproducible del cierre técnico, reinicio, snapshot, exportación e importación. |
| `GUIA_COMPANEROS_OVA.md` | Guía para descargar, validar, importar y probar la OVA paso a paso. |
| `03_INFORME_Y_EVIDENCIAS.md` | Estructura del informe PDF, convención de capturas, diagrama de arquitectura y cómo convertir Markdown a PDF. |
| `04_PRESENTACION_DEFENSA.md` | Guion de 20 minutos, reparto por integrante, guion de demo en vivo y banco de preguntas. |
| `05_CHECKLIST_ENTREGA.md` | Lista de verificación final (técnica, documental y de exposición). |
| `REVISION_2026-10-25.md` | Diagnóstico de la revisión, estado real de la VM y cambios aplicados. |
| `plantillas/` | Archivos listos para copiar a `/proyecto/`: `reporte_sistema.sh`, `verificar_proyecto.sh`, `Dockerfile`, `index.html`, `cron-proyecto`, `.gitignore`, `README-proyecto.md`, `docker-compose.yml`, `informe_plantilla.md` e índice de capturas. |

## Orden recomendado de trabajo

1. Leer `00_ANALISIS_Y_PLAN.md` y definir el número de grupo.
2. Revisar la VM existente y configurar los reenvíos NAT con `02_VM_EXPORTAR_IMPORTAR.md` (no crear otra si ya existe).
3. Ejecutar `01_GUIA_PASO_A_PASO.md` de la fase 0 a la 8, capturando evidencias.
4. Exportar la VM y que cada integrante la importe.
5. Redactar el informe con `03_INFORME_Y_EVIDENCIAS.md` y subir todo a GitHub.
6. Preparar y ensayar la defensa con `04_PRESENTACION_DEFENSA.md`.
7. Pasar `05_CHECKLIST_ENTREGA.md` antes de entregar.

## Arquitectura en una imagen

```text
Host Debian 13 + VirtualBox 7.2
│  NAT: 2222→22, 8080→8080, 8081→8081, 8082→8082, 8083→8083
▼
VM Debian 13 «servidor-grupo1» (sin escritorio, por SSH)
├── Docker Engine
│   ├── nginx-basico        :8080  bind mount /proyecto/web (ro)
│   ├── nginx-personalizado :8081  imagen servidor-grupo1 (COPY web/)
│   ├── nginx-red           :8082  red-proyecto + bind mount (ro)
│   └── nginx-volumen       :8083  red-proyecto + volumen-web
├── cron cada 30 min → /var/log/proyecto/reporte_sistema.log
└── Git /proyecto → GitHub proyecto-linux-grupo1
```

## Convención usada en los comandos

En todos los ejemplos se usa el **grupo 1** como ejemplo. Cambia el número por el de tu grupo:

```bash
GRUPO=1                       # <-- cambia solo esto
HOST="servidor-grupo${GRUPO}"
IMAGEN="servidor-grupo${GRUPO}"
```

> `IMAGEN` debe ir en minúsculas porque Docker no acepta nombres de imagen con mayúsculas.

## Cómo llevar las plantillas a la VM

Desde el host (con la VM encendida y el reenvío SSH 2222 activo):

```bash
scp -P 2222 -r <RUTA_DEL_KIT>/plantillas enoc@127.0.0.1:/home/enoc/
```

Reemplaza `<RUTA_DEL_KIT>` por la ruta de esta carpeta.

Luego, dentro de la VM:

```bash
sudo cp /home/enoc/plantillas/reporte_sistema.sh /proyecto/scripts/
sudo cp /home/enoc/plantillas/verificar_proyecto.sh /proyecto/scripts/
sudo cp /home/enoc/plantillas/Dockerfile /proyecto/
sudo cp /home/enoc/plantillas/index.html /proyecto/web/
sudo cp /home/enoc/plantillas/cron-proyecto /etc/cron.d/proyecto
sudo chown adminsys:adminsys /proyecto/Dockerfile /proyecto/web/index.html
sudo chown root:root /etc/cron.d/proyecto
sudo chmod 755 /proyecto/scripts/*.sh
sudo chmod 644 /etc/cron.d/proyecto
```

## Reglas de oro del proyecto

- Cada fase se **verifica** antes de pasar a la siguiente; cada verificación se **captura**.
- Los contenedores se ejecutan con `--restart unless-stopped` para que sobrevivan a un reinicio de la VM.
- Ninguna contraseña, token de GitHub ni clave SSH se sube al repositorio.
- Todos los integrantes deben tener commits propios: el historial de Git es parte de la nota.
- La VM exportada debe estar **apagada** y con los servicios ya funcionando.

## Notas importantes detectadas en el enunciado

- El PDF escribe **«técnico»** con tilde, pero el usuario del sistema debe ser `tecnico` (Linux no admite tildes).
- El nombre de la imagen `servidor-grupoX` debe ir en **minúsculas**.
- Los puertos son fijos: **8080, 8081, 8082 y 8083**.
- La herencia de grupo se logra con **setgid** (`chmod 2775`) y se comprueba creando archivos con `tecnico` y `visitante`.
- El repositorio debe mostrar commits de **los 4 integrantes**.
- La entrega es el **3 de noviembre**; si la defensa es antes, adelanta el cronograma.

## Estado real del proyecto

La implementación técnica del **Grupo 7** está terminada:

- Fases 0 a 8 verificadas y documentadas.
- Docker, cron, Git/GitHub, Nginx, imagen propia, red y volumen funcionando.
- Reinicio comprobado con recuperación automática de los cuatro contenedores.
- Snapshot final `08-final` verificado.
- OVA final exportada, checksum validado e importación probada como
  `servidor-grupo7-copia`.
- Cuatro puertos `HTTP 200` tanto dentro de la copia como desde el host.

Artefactos principales:

| Artefacto | Ruta |
|---|---|
| Estado completo | `ESTADO_PROYECTO.md` |
| Comandos de cierre F8 | `FASE_8_COMANDOS.md` |
| Evidencias F08 | `evidencias/F08/` |
| Evidencias de exportación/importación | `evidencias/OVA/` |
| OVA final | `/home/enoc/Descargas/proyecto-isl135-grupo7.ova` |
| SHA-256 | `/home/enoc/Descargas/proyecto-isl135-grupo7.ova.sha256` |

SHA-256:

```text
249cae68a705ce772a249dd6d78aa3eaa86219b67b4409216c0928798067dcd4
```

La OVA mide aproximadamente 4.2 GB y no debe subirse a GitHub. Falta cerrar el
informe PDF y la presentación. Si el docente exige un equipo distinto, también
falta trasladar la OVA y repetir allí la prueba de importación.
