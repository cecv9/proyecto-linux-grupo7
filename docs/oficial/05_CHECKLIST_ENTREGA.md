# Checklist de entrega

> Pasa esta lista el **2 de noviembre** y otra vez el **día de la entrega**. Si algo
> falla, corrígelo antes de enviar; no confíes en «lo arreglo en la defensa».

---

## 1. Checklist técnico (fase por fase)

### Fase 1 — Entorno
- [x] `hostname` devuelve `servidor-grupo7`.
- [x] `hostnamectl` muestra el hostname estático.
- [x] Existen `adminsys`, `tecnico` y `visitante`.
- [x] `adminsys` está en `sudo` y puede ejecutar `sudo whoami`.
- [x] `tecnico` está en `soporte`.
- [x] `visitante` está en `web`.
- [x] Existen `/proyecto/datos`, `web`, `scripts`, `capturas`.
- [x] `datos` tiene grupo `soporte` y bit setgid.
- [x] `web` tiene grupo `web` y bit setgid.
- [x] Un archivo creado por `tecnico` en `datos` hereda el grupo `soporte`.
- [x] Un archivo creado por `visitante` en `web` hereda el grupo `web`.

Comprobación rápida:

```bash
hostnamectl
id adminsys; id tecnico; id visitante
ls -ld /proyecto/datos /proyecto/web
```

### Fase 2 — Automatización
- [x] `/proyecto/scripts/reporte_sistema.sh` existe y es ejecutable.
- [x] El script muestra fecha, hostname, usuarios, disco, RAM y contenedores.
- [x] `/etc/cron.d/proyecto` existe y es propiedad de root.
- [x] El servicio `cron` está activo y habilitado.
- [x] `/var/log/proyecto/reporte_sistema.log` existe y se actualiza.
- [x] Hay al menos dos entradas separadas ~30 minutos.

```bash
ls -l /proyecto/scripts/reporte_sistema.sh
cat /etc/cron.d/proyecto
systemctl is-active cron
sudo tail -n 20 /var/log/proyecto/reporte_sistema.log
```

### Fase 3 — Git y GitHub
- [x] `/proyecto/.git` existe.
- [x] El primer commit contiene la estructura y el README se agregó después del primer push.
- [x] Hay commits con los nombres de los 4 integrantes.
- [x] `origin` apunta a `proyecto-linux-grupo7`.
- [x] El repositorio está actualizado (`git status` limpio).
- [x] El README explica instalación, arquitectura y puertos.
- [x] No hay contraseñas, tokens ni claves en el repositorio.

```bash
cd /proyecto
git log --format='%h | %an | %s' --all
git remote -v
git status
```

### Fase 4 — Docker
- [x] `docker --version` funciona.
- [x] `systemctl is-active docker` devuelve `active`.
- [x] `adminsys` y `tecnico` están en el grupo `docker`.
- [x] `hello-world` se ejecutó correctamente.
- [x] `docker ps -a` muestra el contenedor de prueba.

```bash
docker version
systemctl is-active docker
getent group docker
docker ps -a
```

### Fase 5 — Nginx 8080
- [x] `nginx-basico` está corriendo.
- [x] El puerto 8080 responde 200.
- [x] El navegador muestra el `index.html` personalizado.
- [x] `docker logs nginx-basico` no muestra errores.
- [x] El bind mount apunta a `/proyecto/web`.

```bash
docker ps --filter name=nginx-basico
curl -I http://localhost:8080
docker inspect -f '{{json .Mounts}}' nginx-basico
```

### Fase 6 — Imagen propia 8081
- [x] Existe `/proyecto/Dockerfile`.
- [x] La imagen `servidor-grupo7` está construida.
- [x] `nginx-personalizado` corre en 8081.
- [x] El navegador muestra el sitio en 8081.
- [x] Puedes explicar la diferencia entre 8080 y 8081.

```bash
docker images | grep servidor-grupo7
curl -I http://localhost:8081
```

### Fase 7 — Red y volumen
- [x] Existe la red `red-proyecto`.
- [x] `nginx-red` está conectado a la red y responde en 8082.
- [x] Existe el volumen `volumen-web`.
- [x] `nginx-volumen` lo usa y responde en 8083.
- [x] El contenido sobrevive al eliminar y recrear el contenedor.

```bash
docker network inspect red-proyecto
docker volume inspect volumen-web
curl -I http://localhost:8082
curl -I http://localhost:8083
```

### Fase 8 — Pruebas
- [x] `ping` desde Alpine a `nginx-red` funciona con 0 % de pérdida.
- [x] Los 4 puertos responden 200.
- [x] `docker ps` muestra los 4 contenedores.
- [x] El log de cron está actualizado.
- [x] Tras `sudo reboot`, los 4 contenedores vuelven a estar activos.
- [x] `verificar_proyecto.sh` pasa antes y después del reinicio.
- [x] Las evidencias F08 están publicadas y Git quedó limpio.

```bash
docker run --rm -it --network red-proyecto alpine ping -c 4 nginx-red
for p in 8080 8081 8082 8083; do curl -s -o /dev/null -w "$p %{http_code}\n" http://localhost:$p; done
docker ps
```

---

## 2. Checklist documental

- [ ] Portada con universidad, facultad, materia, título, grupo, integrantes, docente y fecha.
- [ ] Índice generado.
- [ ] Introducción y objetivos.
- [ ] Arquitectura con diagrama y tabla de puertos.
- [ ] Las 8 fases desarrolladas con objetivo, comandos, explicación y verificación.
- [ ] Capturas de cada fase (mínimo las del apéndice C de la guía).
- [ ] Dificultades y soluciones.
- [ ] Conclusiones.
- [ ] Bibliografía.
- [ ] Anexos con scripts y Dockerfile.
- [ ] PDF revisado en otro dispositivo y con numeración.

---

## 3. Checklist del repositorio

- [x] Estructura completa (`datos`, `web`, `scripts`, `capturas`, `Dockerfile`, `README.md`).
- [x] `reporte_sistema.sh` y `verificar_proyecto.sh`.
- [x] `cron-proyecto` documentado.
- [x] `Dockerfile` y `.dockerignore`.
- [x] README completo.
- [x] `.gitignore` funcional.
- [x] Historial con commits de los 4 integrantes.
- [x] Sin secretos.
- [ ] Enlace del repositorio probado en una ventana privada (público) o con un colaborador (privado).

---

## 4. Checklist de la VM y la OVA

- [x] La VM arranca y los servicios vuelven solos.
- [x] Los reenvíos NAT `2222`, `8080`, `8081`, `8082` y `8083` existen.
- [ ] Contraseñas de `enoc`, `adminsys`, `tecnico` y `visitante` definidas y compartidas de forma privada.
- [x] Snapshot `08-final` o `pre-defensa`.
- [x] OVA exportada con la VM apagada.
- [x] La OVA fue reexportada después de configurar los reenvíos NAT.
- [x] SHA256 generado y verificado.
- [ ] OVA importada y probada en al menos otra computadora.
- [x] Reenvío de puertos documentado para quien importe.
- [x] La OVA no se subió a GitHub.

> La OVA fue importada y probada como una VM independiente
> (`servidor-grupo7-copia`) en este mismo host. Si el docente exige una máquina
> distinta, la prueba externa sigue pendiente.

---

## 5. Checklist de la presentación

- [ ] 15 diapositivas revisadas.
- [ ] Reparto de tiempos acordado.
- [ ] Los 4 integrantes hablan.
- [ ] Demo ensayada al menos dos veces.
- [ ] Video de respaldo grabado.
- [ ] Cámaras y micrófonos probados.
- [ ] Preguntas de la sección 4 de `04_PRESENTACION_DEFENSA.md` repasadas.
- [ ] Cronómetro y guion a la vista.

---

## 6. Checklist del día de la entrega

- [ ] PDF final subido o entregado según indique el docente.
- [ ] Enlace del repositorio compartido y accesible.
- [ ] Presentación lista.
- [ ] VM encendida y servicios activos (si la demo es en vivo).
- [ ] Copia del PDF, del repositorio y del video en un pendrive o en la nube.
- [ ] Llegar 15 minutos antes.

---

## 7. Lo que NO debes hacer

- No entregues con un solo integrante en el historial de Git.
- No subas contraseñas, tokens ni claves SSH.
- No ejecutes `docker system prune -a` antes de la defensa.
- No cambies los puertos sin actualizar el informe y las capturas.
- No dejes los contenedores sin política de reinicio.
- No presentes sin haber probado la OVA en otra máquina.
- No leas las diapositivas ni improvises la demo.

---

## 8. Frase final

Si puedes ejecutar el script de verificación y ver los 4 puertos en 200, el cron actualizándose, el repositorio con commits de los 4 y la OVA importada en otra computadora, **el proyecto está listo**.
