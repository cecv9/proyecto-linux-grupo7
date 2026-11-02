# Guía para ordenar el informe del proyecto

Esta guía sirve para convertir el borrador `DOCUMENTACIONP.docx` en un informe
final ordenado, con la misma estructura de fases que el repositorio.

> **Atajo:** el repositorio ya incluye dos borradores generados:
> [`docs/INFORME_FINAL_GRUPO7_RESUMIDO.md`](docs/INFORME_FINAL_GRUPO7_RESUMIDO.md)
> (53 evidencias clave, recomendado para entregar) y
> [`docs/INFORME_FINAL_GRUPO7.md`](docs/INFORME_FINAL_GRUPO7.md)
> (269 evidencias, útil como anexo). Puedes usarlos como base y ajustar la
> redacción.

## 1. Estructura recomendada del informe

```text
1. Portada
2. Índice
3. Introducción
4. Objetivos
5. Arquitectura del proyecto
6. Fase 00 — Preparación del entorno
7. Fase 01 — Administración básica, usuarios y permisos
8. Fase 02 — Automatización y monitoreo
9. Fase 03 — Control de versiones y GitHub
10. Fase 04 — Instalación y configuración de Docker
11. Fase 05 — Servidor web Nginx básico
12. Fase 06 — Imagen personalizada con Dockerfile
13. Fase 07 — Redes y volúmenes de Docker
14. Fase 08 — Pruebas y verificación final
15. Conclusiones
16. Recomendaciones
17. Bibliografía
18. Anexos
```

## 2. Ordenar el documento en Word, paso a paso

### Paso 1: Crear la portada

Incluye:

- Universidad de El Salvador.
- Facultad Multidisciplinaria de Occidente.
- Departamento de Ingeniería y Arquitectura.
- Asignatura: Introducción al Software Libre.
- Título: “Servidor Linux automatizado con Docker, cron y Git”.
- Grupo 7.
- Integrantes con carné.
- Docente.
- Fecha: martes 3 de noviembre de 2026.

### Paso 2: Configurar estilos

En Word:

1. Pestaña **Inicio → Estilos**.
2. Usa **Título 1** para las fases y capítulos.
3. Usa **Título 2** para “Objetivo”, “Comandos”, “Evidencias” y “Resultado”.
4. Usa **Normal** para el texto.
5. Justifica el texto y usa interlineado 1.15.

Así podrás generar el índice automático.

### Paso 3: Insertar el índice

1. Coloca el cursor después de la portada.
2. **Referencias → Tabla de contenido → Tabla automática**.
3. Al final, actualiza el índice con **F9** o **Actualizar tabla**.

### Paso 4: Escribir la introducción y los objetivos

La introducción debe responder:

- ¿Qué problema resuelve el proyecto?
- ¿Por qué se usó Debian, Docker, Nginx, cron y Git?
- ¿Qué se espera demostrar?

Los objetivos pueden ser:

- Implementar un servidor Linux con servicios web containerizados.
- Automatizar el monitoreo con Bash y cron.
- Versionar el proyecto con Git y GitHub.
- Verificar el funcionamiento integral del servidor.

### Paso 5: Insertar la arquitectura

Incluye un diagrama como este:

```text
VirtualBox
└── Debian 13 (servidor-grupo7)
    ├── /proyecto
    ├── cron → reporte_sistema.sh → /var/log/proyecto/reporte_sistema.log
    └── Docker
        ├── 8080 nginx-basico        (bind mount)
        ├── 8081 nginx-personalizado (imagen propia)
        ├── 8082 nginx-red           (red-proyecto)
        └── 8083 nginx-volumen       (volumen-web)
```

Explica cada puerto y qué técnica demuestra.

### Paso 6: Desarrollar cada fase

Para cada fase, usa esta plantilla:

```text
FASE 0X — Título de la fase

Objetivo:
...

Comandos ejecutados:
[bloque de código]

Evidencias:
Figura 1. Descripción de la imagen.
[imagen]

Explicación:
Qué se hizo, por qué se hizo y qué resultado se obtuvo.
```

Puedes copiar el objetivo, los comandos y las descripciones desde:

- `capturas/fase-00-preparacion/README.md`
- `capturas/fase-01-administracion-basica/README.md`
- `capturas/fase-02-automatizacion-monitoreo/README.md`
- `capturas/fase-03-control-versiones/README.md`
- `capturas/fase-04-docker/README.md`
- `capturas/fase-05-nginx-basico/README.md`
- `capturas/fase-06-imagen-personalizada/README.md`
- `capturas/fase-07-redes-volumenes/README.md`
- `capturas/fase-08-pruebas-verificacion/README.md`

### Paso 7: Poner pies de figura

Cada imagen debe tener un pie. Usa este formato:

```text
Figura 12. Verificación del puerto 8080 con curl -I.
Fuente: elaboración propia.
```

No dejes imágenes sin explicar. La rúbrica pide “capturas de pantalla de cada
comando ejecutado” y “evidencias de todos los servicios funcionando”.

### Paso 8: Insertar la verificación final

Incluye:

- Salida de `docker ps`.
- Los 4 puertos con `200`.
- Salida de `verificar_proyecto.sh`.
- `git status` limpio.
- `git log --oneline` con los commits.
- Prueba después del reinicio.

Puedes usar las evidencias de `capturas/fase-08-pruebas-verificacion/`.

### Paso 9: Conclusiones y recomendaciones

Conclusiones:

- El servidor quedó funcionando con 4 servicios web.
- La automatización con cron registra el estado cada 30 minutos.
- Git permitió el trabajo colaborativo y la trazabilidad.
- Docker facilitó la reproducción del entorno.

Recomendaciones:

- Usar `docker compose` para declarar los 4 servicios.
- Fijar versiones de imágenes en lugar de `latest`.
- Implementar HTTPS.
- Usar usuario no root dentro de los contenedores.
- Gestionar secretos con Docker secrets.
- Agregar respaldos y monitoreo.

### Paso 10: Anexos

Incluye:

- Enlace al repositorio: `https://github.com/cecv9/proyecto-linux-grupo7`.
- README del proyecto.
- Historial de commits.
- Tabla de integrantes y aportes.
- Capturas adicionales.

### Paso 11: Exportar a PDF

1. **Archivo → Guardar como → PDF**.
2. Nombre: `Informe_Proyecto_ISL135_Grupo7.pdf`.
3. Revisa que el índice tenga números de página.
4. Revisa que no haya contraseñas ni datos sensibles.
5. Revisa que las imágenes se vean nítidas.

## 3. Qué quitar del borrador actual

En `DOCUMENTACIONP.docx` hay que corregir:

- Contraseñas en texto plano. Elimínalas.
- Frases de conversación como “Pégame lo que aparezca” o “Lo hiciste
  correctamente”. Reescríbelas en tercera persona.
- La fase 8 no aparece desarrollada. Agrégala.
- Falta la portada, el índice, la introducción, las conclusiones y los anexos.
- Algunas capturas no tienen pie de figura.

## 4. Checklist antes de entregar

- [ ] Portada completa.
- [ ] Índice automático actualizado.
- [ ] Introducción y objetivos.
- [ ] Arquitectura explicada.
- [ ] Las 9 fases (00 a 08) desarrolladas.
- [ ] Cada fase con objetivo, comandos, capturas y explicación.
- [ ] Cada imagen con pie de figura.
- [ ] Verificación final incluida.
- [ ] Conclusiones y recomendaciones.
- [ ] Enlace al repositorio.
- [ ] Sin contraseñas ni claves.
- [ ] Exportado a PDF.
- [ ] PDF revisado página por página.
