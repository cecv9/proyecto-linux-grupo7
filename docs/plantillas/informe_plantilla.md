<!-- Si usas Word o Google Docs, elimina el bloque YAML de abajo y reemplaza
     cada \newpage por un salto de página manual. -->

---
title: "Proyecto Final: Servidor Linux automatizado con Docker"
subtitle: "Introducción al Software Libre — Ciclo II 2026"
author: "Grupo 1"
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

**Grupo:** 1
**Integrantes:**

- Nombre completo — carné — usuario de GitHub
- Nombre completo — carné — usuario de GitHub
- Nombre completo — carné — usuario de GitHub
- Nombre completo — carné — usuario de GitHub

**Docente:** Nombre del docente
**Fecha de entrega:** 03 de noviembre de 2026

\newpage

# Índice

<!-- Genera el índice con Pandoc (--toc) o con el procesador de textos. -->

\newpage

# Introducción

<!-- 2-3 párrafos: contexto, importancia del software libre, qué se construyó y por qué. -->

# Objetivos

## Objetivo general

Implementar un servidor Linux automatizado mediante Docker, integrando administración
de usuarios y permisos, automatización con Bash y cron, control de versiones y
servicios web containerizados.

## Objetivos específicos

1. Configurar hostname, usuarios, grupos, sudo y permisos con herencia de grupo.
2. Automatizar un reporte del sistema cada 30 minutos.
3. Versionar el proyecto en Git y GitHub con commits de todos los integrantes.
4. Instalar Docker y desplegar cuatro servicios Nginx con técnicas distintas.
5. Construir una imagen personalizada, una red y un volumen persistente.
6. Verificar la conectividad y documentar cada fase con evidencias.

# Marco teórico

<!-- Breve: Linux/Debian, virtualización, Docker (imagen, contenedor, Dockerfile,
     bind mount, volumen, red bridge), Git, cron, Nginx. Solo lo que uses. -->

# Arquitectura de la solución

<!-- Incluye el diagrama de arquitectura y la tabla de puertos. Explica el flujo
     host → VirtualBox NAT → VM → Docker → contenedores. -->

| Puerto | Contenedor | Técnica |
|---|---|---|
| 8080 | nginx-basico | Bind mount |
| 8081 | nginx-personalizado | Imagen propia |
| 8082 | nginx-red | Red personalizada |
| 8083 | nginx-volumen | Volumen persistente |

# Fase 1 — Preparación del entorno servidor

## 1.1 Administración básica del sistema

### Objetivo
<!-- ... -->

### Desarrollo
<!-- Comandos y explicación: hostnamectl, adduser, groupadd, usermod. -->

### Evidencias
<!-- Figura F01_01, F01_02, F01_03 -->

### Verificación
<!-- Salida de id, getent group, sudo whoami. -->

### Conclusión
<!-- ... -->

## 1.2 Estructura de directorios y permisos

### Objetivo
<!-- ... -->

### Desarrollo
<!-- mkdir, chown, chgrp, chmod 2775, setgid. -->

### Evidencias
<!-- F01_04, F01_05 -->

### Verificación
<!-- ls -ld, archivos de tecnico y visitante. -->

### Conclusión
<!-- ... -->

# Fase 2 — Automatización y monitoreo

## 2.1 Script de monitoreo del sistema

<!-- Objetivo, contenido del script, explicación de cada comando, evidencia F02_01. -->

## 2.2 Automatización con cron

<!-- /etc/cron.d/proyecto, formato de cron, prueba de 1 minuto, log con
     timestamps, evidencia F02_02 y F02_03. -->

# Fase 3 — Control de versiones

## 3.1 Repositorio local

<!-- git init, .gitignore, estructura, primer commit; README después del push, evidencia F03_01. -->

## 3.2 Repositorio remoto en GitHub

<!-- Creación del repo, SSH/PAT, remote, push, evidencia F03_02 y F03_03. -->

## 3.3 Trabajo colaborativo

<!-- Ramas, Pull Requests, commits de los 4, evidencia F03_04. -->

# Fase 4 — Docker

## 4.1 Instalación y configuración

<!-- Repositorio oficial, docker-ce, systemctl, grupo docker, evidencias F04_01 y F04_02. -->

## 4.2 Verificación inicial

<!-- hello-world, docker ps -a, evidencia F04_03. -->

# Fase 5 — Servidor web containerizado (8080)

## 5.1 Contenedor Nginx básico

<!-- index.html, docker run -d -p 8080:80 -v /proyecto/web:..., evidencia F05_01. -->

## 5.2 Verificación del servicio web

<!-- Navegador, curl, logs, evidencias F05_02 y F05_03. -->

# Fase 6 — Docker avanzado (8081)

## 6.1 Dockerfile personalizado

<!-- FROM, COPY, EXPOSE, CMD; build; evidencia F06_01 y F06_02. -->

## 6.2 Contenedor con imagen personalizada

<!-- docker run -p 8081:80, verificación, comparación con 8080, evidencias F06_03 y F06_04. -->

# Fase 7 — Redes y volúmenes Docker (8082 y 8083)

## 7.1 Red personalizada

<!-- docker network create, nginx-red, inspect, evidencia F07_01 y F07_02. -->

## 7.2 Volúmenes persistentes

<!-- docker volume create, nginx-volumen, docker cp, persistencia, evidencias F07_03 y F07_04. -->

# Fase 8 — Pruebas y verificación final

## 8.1 Pruebas de conectividad

<!-- Alpine + ping, evidencia F08_01. -->

## 8.2 Verificación integral

<!-- docker ps, 4 puertos, cron, git status, reinicio, evidencias F08_02 a F08_05. -->

# Resultados

<!-- Tabla resumen: servicio, puerto, estado, evidencia. Captura final de los 4 puertos. -->

# Dificultades y soluciones

<!-- 2-3 problemas reales: error, causa, solución, aprendizaje. -->

# Conclusiones

<!-- Qué se logró, qué se aprendió, relación con el software libre. -->

# Recomendaciones y trabajo futuro

<!-- HTTPS, Docker Compose, CI/CD, monitoreo, backups, Docker rootless. -->

# Bibliografía

<!-- Debian, Docker, Nginx, Git, cron. Formato APA o IEEE. -->

# Anexos

## Anexo A — Script reporte_sistema.sh

```bash
<!-- Pega el script completo -->
```

## Anexo B — Dockerfile

```dockerfile
<!-- Pega el Dockerfile completo -->
```

## Anexo C — Cron

```text
<!-- Pega /etc/cron.d/proyecto -->
```

## Anexo D — README del repositorio

<!-- Enlace y resumen. -->
