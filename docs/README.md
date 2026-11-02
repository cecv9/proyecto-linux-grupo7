# Documentación del proyecto

Esta carpeta reúne la documentación oficial del proyecto y las plantillas de
apoyo. El código y las evidencias siguen en la raíz del repositorio:

- `scripts/`: automatización y verificación.
- `web/`: sitio servido por Nginx.
- `Dockerfile`: imagen personalizada.
- `capturas/`: evidencias organizadas por fase.

## Documentación oficial

| Archivo | Contenido |
|---|---|
| [`oficial/README_OFICIAL.md`](oficial/README_OFICIAL.md) | Índice general de la documentación oficial. |
| [`oficial/00_ANALISIS_Y_PLAN.md`](oficial/00_ANALISIS_Y_PLAN.md) | Análisis del enunciado, arquitectura, decisiones y cronograma. |
| [`oficial/01_GUIA_PASO_A_PASO.md`](oficial/01_GUIA_PASO_A_PASO.md) | Comandos exactos de las fases 0 a 8. |
| [`oficial/02_VM_EXPORTAR_IMPORTAR.md`](oficial/02_VM_EXPORTAR_IMPORTAR.md) | Crear, exportar e importar la VM en VirtualBox. |
| [`oficial/03_INFORME_Y_EVIDENCIAS.md`](oficial/03_INFORME_Y_EVIDENCIAS.md) | Estructura del informe, capturas y conversión a PDF. |
| [`oficial/04_PRESENTACION_DEFENSA.md`](oficial/04_PRESENTACION_DEFENSA.md) | Guion de 20 minutos, demo y banco de preguntas. |
| [`oficial/05_CHECKLIST_ENTREGA.md`](oficial/05_CHECKLIST_ENTREGA.md) | Checklist técnico, documental y de exposición. |
| [`oficial/ESTADO_PROYECTO.md`](oficial/ESTADO_PROYECTO.md) | Estado real de la VM, snapshots, OVA y fases. |
| [`oficial/FASE_2_COMANDOS.md`](oficial/FASE_2_COMANDOS.md) | Comandos de la fase 2. |
| [`oficial/FASE_3_COMANDOS.md`](oficial/FASE_3_COMANDOS.md) | Comandos de la fase 3. |
| [`oficial/FASE_4_COMANDOS.md`](oficial/FASE_4_COMANDOS.md) | Comandos de la fase 4. |
| [`oficial/FASE_5_COMANDOS.md`](oficial/FASE_5_COMANDOS.md) | Comandos de la fase 5. |
| [`oficial/FASE_6_COMANDOS.md`](oficial/FASE_6_COMANDOS.md) | Comandos de la fase 6. |
| [`oficial/FASE_7_COMANDOS.md`](oficial/FASE_7_COMANDOS.md) | Comandos de la fase 7. |
| [`oficial/FASE_8_COMANDOS.md`](oficial/FASE_8_COMANDOS.md) | Comandos de la fase 8. |
| [`oficial/GUIA_COMPANEROS_OVA.md`](oficial/GUIA_COMPANEROS_OVA.md) | Cómo descargar, validar e importar la OVA. |
| [`oficial/FASE_3_CONTRIBUCIONES_EQUIPO.md`](oficial/FASE_3_CONTRIBUCIONES_EQUIPO.md) | Aportes y trabajo colaborativo. |
| [`oficial/FASE_3_README_GRUPO7.md`](oficial/FASE_3_README_GRUPO7.md) | README específico del Grupo 7. |

> Algunos ejemplos de la documentación oficial usan el Grupo 1 como modelo.
> Este repositorio corresponde al **Grupo 7**: hostname `servidor-grupo7`,
> imagen `servidor-grupo7` y repositorio `proyecto-linux-grupo7`.

## Plantillas

En [`plantillas/`](plantillas/) están los archivos base:

- `informe_plantilla.md`
- `README-proyecto.md`
- `docker-compose.yml`
- `Dockerfile`
- `index.html`
- `cron-proyecto`
- `reporte_sistema.sh`
- `verificar_proyecto.sh`
- `.gitignore`
- `capturas/INDICE.md`

## Borradores del informe

| Archivo | Uso |
|---|---|
| [`INFORME_FINAL_GRUPO7_RESUMIDO.md`](INFORME_FINAL_GRUPO7_RESUMIDO.md) | Versión recomendada para entregar: incluye las 53 evidencias clave. |
| [`INFORME_FINAL_GRUPO7.md`](INFORME_FINAL_GRUPO7.md) | Versión completa con las 269 evidencias, útil como anexo o fuente de consulta. |

Para convertirlos a PDF desde la raíz del repositorio:

```bash
pandoc docs/INFORME_FINAL_GRUPO7_RESUMIDO.md \
  -o Informe_Proyecto_ISL135_Grupo7.pdf \
  --pdf-engine=xelatex \
  --resource-path=docs \
  --toc --toc-depth=2 \
  -V geometry:margin=2.5cm \
  -V mainfont="DejaVu Sans" \
  -V lang=es
```

También se pueden abrir en Word o en un editor Markdown y exportar a PDF.

## Guías propias del repositorio

- [`../GUIA_VM.md`](../GUIA_VM.md): cómo importar, encender y verificar la VM.
- [`../GUIA_INFORME.md`](../GUIA_INFORME.md): cómo ordenar el informe y exportarlo a PDF.
- [`../capturas/INDICE.md`](../capturas/INDICE.md): índice de evidencias por fase.

## Datos de la VM y la OVA

| Dato | Valor |
|---|---|
| Nombre en VirtualBox | `Debian 13` |
| Hostname | `servidor-grupo7` |
| Copia importada | `servidor-grupo7-copia` |
| OVA | `proyecto-isl135-grupo7-001.ova` |
| SHA-256 | `249cae68a705ce772a249dd6d78aa3eaa86219b67b4409216c0928798067dcd4` |
| Puertos | `2222`, `8080`, `8081`, `8082`, `8083` |

La OVA pesa aproximadamente 4.2 GB y **no se sube a GitHub**. Se comparte por
Drive, OneDrive, Mega o pendrive junto con el archivo `.sha256`.
