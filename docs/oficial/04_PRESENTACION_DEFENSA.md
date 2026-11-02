# Presentación y defensa (20 minutos)

> **Reglas del enunciado:** máximo 20 minutos, los 4 integrantes participan, todos con
> cámara activa, demostración en vivo y respuestas a preguntas del docente.

---

## 1. Reparto del tiempo

| Tramo | Quién | Contenido |
|---|---|---|
| 0:00–3:30 | A | Portada, objetivo, arquitectura y fase 1 |
| 3:30–7:30 | B | Fases 2 y 3 (script, cron, Git) |
| 7:30–11:30 | C | Fases 4 y 5 (Docker, Nginx 8080) |
| 11:30–15:30 | D | Fases 6, 7 y 8 (imagen, red, volumen, pruebas) |
| 15:30–18:30 | Todos (coordina D) | Demostración en vivo: cada uno muestra su fase |
| 18:30–20:00 | A | Conclusiones, aprendizajes y cierre |

> Deja 1–2 minutos de margen. Si te pasas de 20, el docente puede cortar la exposición.

---

## 2. Guion de diapositivas (15)

1. **Portada:** universidad, materia, título, grupo, integrantes, fecha.
2. **Problema y objetivo:** qué se pidió y qué se construyó.
3. **Alcance:** las 8 fases en una línea de tiempo.
4. **Arquitectura:** diagrama, puertos y componentes.
5. **Fase 1:** hostname, usuarios, grupos, setgid (captura clave).
6. **Fase 2:** script y cron; muestra el log con timestamps.
7. **Fase 3:** Git local/remoto, README y commits de los 4.
8. **Fase 4:** instalación de Docker, grupo docker y `hello-world`.
9. **Fase 5:** Nginx 8080, bind mount y verificación.
10. **Fase 6:** Dockerfile, imagen `servidor-grupo1`, 8081 y comparación.
11. **Fase 7:** red `red-proyecto`, volumen `volumen-web`, 8082/8083.
12. **Fase 8:** `ping` con Alpine y verificación integral.
13. **Resultados:** tabla de puertos, `docker ps`, log y Git.
14. **Dificultades y soluciones:** 2–3 errores reales y cómo se corrigieron.
15. **Conclusiones y preguntas:** aprendizajes, relación con el software libre y gracias.

Consejos de diseño: fondo claro, letra grande (mínimo 24 pt), poco texto por diapositiva, capturas nítidas y una idea por diapositiva. No leas las diapositivas.

---

## 3. Demostración en vivo (3 minutos)

> Reparte la demo: **A** muestra usuarios/permisos, **B** el script y Git, **C** Docker y el 8080, **D** el 8081, la red, el volumen y el `ping`. Así los cuatro participan también en la demostración.

### 3.1 Antes de empezar

- [ ] VM encendida y conectada por SSH.
- [ ] Los 4 contenedores corriendo (`docker ps`).
- [ ] Pestañas del navegador abiertas en 8080, 8081, 8082 y 8083.
- [ ] Terminal con fuente grande y prompt visible.
- [ ] `verificar_proyecto.sh` copiado y ejecutable.
- [ ] Video pregrabado de respaldo en el escritorio.
- [ ] Snapshot `pre-defensa` tomado (no restaurar durante la demo).

### 3.2 Secuencia recomendada

```bash
# 1. Identidad del servidor
hostnamectl
id adminsys

# 2. Permisos y herencia
ls -ld /proyecto/datos /proyecto/web
ls -l /proyecto/web/index.html

# 3. Monitoreo y cron
/proyecto/scripts/reporte_sistema.sh
sudo tail -n 6 /var/log/proyecto/reporte_sistema.log

# 4. Git
cd /proyecto
git log --oneline -5
git remote -v

# 5. Contenedores
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'

# 6. Navegador: 8080, 8081, 8082, 8083

# 7. Red
docker run --rm -it --network red-proyecto alpine ping -c 2 nginx-red

# 8. Verificación integral
/proyecto/scripts/verificar_proyecto.sh
```

Mientras ejecutas, narra: «este es el hostname», «este es el bind mount», «este es el volumen», etc. No ejecutes comandos que no hayas probado.

### 3.3 Plan B

| Falla | Qué hacer |
|---|---|
| El navegador no abre un puerto | Muestra la captura ya tomada y explica; revisa `curl` dentro de la VM |
| SSH no conecta | Usa la consola de VirtualBox |
| Docker no responde | `sudo systemctl restart docker`; si falla, muestra el video |
| Internet caído | Ten el repo clonado y capturas locales; no dependas de GitHub en vivo |
| La VM no arranca | Usa otra copia importada o el video pregrabado |

---

## 4. Preguntas probables y respuestas

**1. ¿Diferencia entre imagen y contenedor?**
La imagen es la plantilla inmutable (capas de solo lectura); el contenedor es una instancia en ejecución con una capa escribible. Puedes crear muchos contenedores desde una imagen.

**2. ¿Bind mount o volumen?**
El bind mount usa una ruta del host (`/proyecto/web`); el volumen lo gestiona Docker (`/var/lib/docker/volumes/volumen-web`). El bind mount es cómodo para desarrollo; el volumen es mejor para datos persistentes y portabilidad.

**3. ¿Qué hace el bit setgid en `datos` y `web`?**
Hace que los archivos y subdirectorios nuevos hereden el grupo del directorio, en lugar del grupo primario del usuario que los crea. Se ve como `drwxrwsr-x`.

**4. ¿Qué significa `-p 8080:80`?**
Publica el puerto 8080 del host hacia el puerto 80 del contenedor. El tráfico del host llega a Nginx.

**5. ¿Qué pasa si reinicio la VM?**
Docker está habilitado (`systemctl enable docker`), los contenedores tienen `--restart unless-stopped`, cron está habilitado y el volumen persiste. Por eso los servicios vuelven solos.

**6. ¿Por qué el grupo `docker` es riesgoso?**
Quien puede usar el socket de Docker puede ejecutar un contenedor privilegiado y montar el sistema de archivos del host; en la práctica equivale a root. Se mitiga con acceso restringido, auditoría o Docker rootless.

**7. ¿Cómo se comunican los contenedores?**
En una red definida por el usuario, Docker ofrece DNS interno: `nginx-red` se resuelve por nombre. Alpine hace `ping nginx-red` sin conocer la IP.

**8. ¿Diferencia entre la red por defecto y `red-proyecto`?**
La red `bridge` por defecto no resuelve nombres por DNS y es más compartida; una red definida por el usuario aísla y permite resolución por nombre.

**9. ¿Cómo actualizas el sitio en 8080 y en 8081?**
En 8080 editas `/proyecto/web/index.html` y recargas: el bind mount se refleja al instante. En 8081 hay que reconstruir la imagen (`docker build`) y recrear el contenedor, porque el contenido está dentro de la imagen.

**10. ¿Cómo sabes que cron se ejecuta cada 30 minutos?**
El log muestra entradas con timestamps separados ~30 minutos; además `systemctl status cron` y `journalctl -u cron` confirman la ejecución.

**11. ¿Dónde se guarda el volumen?**
En `/var/lib/docker/volumes/volumen-web/_data` del host. `docker volume inspect` muestra el punto de montaje.

**12. ¿Qué pasa si borras el contenedor 8083?**
El volumen sigue existiendo; al crear un contenedor nuevo con `-v volumen-web:...` el contenido reaparece. Lo demostramos en la fase 7.

**13. ¿Cómo colaboraron en Git?**
Cada integrante creó una rama por fase, hizo commits con su identidad, abrió un Pull Request y otro revisó y fusionó. Nunca se hizo `push --force` a `main`.

**14. ¿Qué es `nginx:latest`?**
La imagen oficial de Nginx en Docker Hub; `latest` es la etiqueta móvil que apunta a la versión más reciente. Para producción conviene fijar una versión.

**15. ¿Qué mejorarían del proyecto?**
HTTPS con Let's Encrypt, Docker Compose para orquestar, CI/CD, monitoreo con Prometheus/Grafana, backups del volumen, Docker rootless y un reverse proxy.

**16. ¿Por qué no usar siempre `sudo docker`?**
El grupo `docker` evita escribir `sudo` en cada comando y es lo que pide el enunciado, pero implica un privilegio alto. La alternativa más segura es Docker rootless o una política de sudo específica.

**17. ¿Cómo verifican que Nginx no tiene errores?**
`docker logs`, `curl -I` con 200, `docker exec nginx-basico nginx -t` para validar la configuración y la comprobación visual en el navegador.

**18. ¿Qué es un Dockerfile?**
Un archivo de texto con las instrucciones para construir una imagen: imagen base, copia de archivos, puertos y comando de inicio.

**19. ¿Por qué `--restart unless-stopped`?**
Para que el contenedor se reinicie automáticamente tras un reinicio o una caída, salvo que lo detengas manualmente. Es clave para la demo.

**20. ¿Qué pasa si un puerto está ocupado?**
Docker falla con «port is already allocated». Se identifica con `ss -tlnp`, se detiene el proceso o se cambia el mapeo (por ejemplo, `-p 18080:80`).

---

## 5. Ensayo y logística

- Hacer **dos ensayos cronometrados** completos, uno con la demo funcionando y otro simulando una falla.
- Cada integrante debe poder responder al menos las preguntas de **su fase** y las generales (1, 2, 5, 6, 15).
- Probar cámara, micrófono, conexión y compartir pantalla 15 minutos antes.
- Tener el PDF, el enlace del repositorio y el video de respaldo en el escritorio.
- No leer; usar las diapositivas como guía.
- Hablar pausado y mirar a la cámara.
- Si una pregunta no se sabe, decir «lo revisamos y respondemos» en lugar de inventar.

---

## 6. Checklist del día de la defensa

- [ ] VM probada y con los 4 servicios activos.
- [ ] Navegador con las 4 pestañas abiertas.
- [ ] Terminal SSH abierta y con fuente grande.
- [ ] Video de respaldo listo.
- [ ] PDF y enlace del repositorio a mano.
- [ ] Diapositivas en el equipo y en la nube.
- [ ] Cámaras y micrófonos probados.
- [ ] Cronómetro visible.
- [ ] Todos saben cuándo les toca hablar.
