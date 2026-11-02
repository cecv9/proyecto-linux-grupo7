# Fase 3 — Contribuciones de Azucena, Ronie y Daniel

> Proyecto Final ISL135 · Grupo 7 · repositorio
> `cecv9/proyecto-linux-grupo7`

Cada integrante debe autenticarse con su propia cuenta de GitHub y crear al
menos un commit. No se deben compartir contraseñas, tokens ni claves SSH.

## Integrantes que faltan

| Integrante | Nombre | GitHub | Rama propuesta |
|---|---|---|---|
| 2 | Azucena del Carmen Castillo Zepeda | `@cz08008-zuz` | `aporte-azucena` |
| 3 | Ronie Odir Portillo Consuegra | `@pc15016-Ronnie` | `aporte-ronie` |
| 4 | Josué Daniel Cruz Arce | `@DanielCruz98-503` | `aporte-daniel` |

## Paso previo del propietario

En GitHub, dentro del repositorio:

1. Abrir **Settings → Collaborators**.
2. Agregar a `cz08008-zuz`, `pc15016-Ronnie` y
   `DanielCruz98-503`.
3. Cada integrante debe aceptar la invitación desde su propia cuenta.

La visibilidad pública permite clonar, pero no permite hacer `push` al
repositorio del propietario. La invitación de colaborador sí concede permiso de
escritura.

## Preparación común en la PC de cada integrante

Cada compañero debe usar su propia cuenta y su propio equipo. Puede usar Linux,
macOS o Git Bash en Windows.

Verificar Git:

```bash
git --version
```

Crear una clave SSH únicamente si no tiene una:

```bash
ssh-keygen -t ed25519 -C "grupo7-github"
```

Mostrar la clave pública:

```bash
cat ~/.ssh/id_ed25519.pub
```

Agregarla en la cuenta de GitHub del integrante:

**Settings → SSH and GPG keys → New SSH key → Authentication Key**.

Comprobar la autenticación:

```bash
ssh -T git@github.com
```

El mensaje debe incluir el usuario de GitHub del integrante. Después, clonar el
repositorio desde la carpeta donde desea trabajar:

```bash
git clone git@github.com:cecv9/proyecto-linux-grupo7.git
cd proyecto-linux-grupo7
```

No se debe clonar dentro de `/proyecto` en la VM, porque crearía un repositorio
Git anidado.

## Aporte de Azucena

Configurar su identidad local:

```bash
git config user.name "Azucena del Carmen Castillo Zepeda"
git config user.email "CORREO_VERIFICADO_DE_SU_CUENTA_GITHUB"
```

Crear la rama:

```bash
git switch main
git pull --rebase
git switch -c aporte-azucena
mkdir -p datos/aportes
```

Crear `datos/aportes/azucena.md` con este contenido:

```markdown
# Aporte de Azucena del Carmen Castillo Zepeda

- Usuario de GitHub: @cz08008-zuz
- Área: automatización y control de versiones.
- Aporte: revisión y documentación del reporte del sistema y su ejecución
  programada mediante cron.
- Fases relacionadas: 2 y 3.
```

Guardar, revisar y subir:

```bash
git status --short
git diff --check
git add datos/aportes/azucena.md
git diff --cached --check
git commit -m "Fase 3: agregar aporte de Azucena Castillo"
git push -u origin aporte-azucena
```

## Aporte de Ronie

Configurar su identidad local:

```bash
git config user.name "Ronie Odir Portillo Consuegra"
git config user.email "CORREO_VERIFICADO_DE_SU_CUENTA_GITHUB"
```

Crear la rama:

```bash
git switch main
git pull --rebase
git switch -c aporte-ronie
mkdir -p datos/aportes
```

Crear `datos/aportes/ronie.md` con este contenido:

```markdown
# Aporte de Ronie Odir Portillo Consuegra

- Usuario de GitHub: @pc15016-Ronnie
- Área: Docker y servidor web base.
- Aporte: revisión y documentación de Docker, la prueba `hello-world` y la
  publicación de Nginx en el puerto 8080.
- Fases relacionadas: 4 y 5.
```

Guardar, revisar y subir:

```bash
git status --short
git diff --check
git add datos/aportes/ronie.md
git diff --cached --check
git commit -m "Fase 3: agregar aporte de Ronie Portillo"
git push -u origin aporte-ronie
```

## Aporte de Daniel

Configurar su identidad local:

```bash
git config user.name "Josué Daniel Cruz Arce"
git config user.email "CORREO_VERIFICADO_DE_SU_CUENTA_GITHUB"
```

Crear la rama:

```bash
git switch main
git pull --rebase
git switch -c aporte-daniel
mkdir -p datos/aportes
```

Crear `datos/aportes/daniel.md` con este contenido:

```markdown
# Aporte de Josué Daniel Cruz Arce

- Usuario de GitHub: @DanielCruz98-503
- Área: imagen personalizada, redes, volúmenes y pruebas.
- Aporte: revisión y documentación de la imagen personalizada, la red
  `red-proyecto`, el volumen `volumen-web` y las pruebas finales.
- Fases relacionadas: 6, 7 y 8.
```

Guardar, revisar y subir:

```bash
git status --short
git diff --check
git add datos/aportes/daniel.md
git diff --cached --check
git commit -m "Fase 3: agregar aporte de Josue Daniel Cruz Arce"
git push -u origin aporte-daniel
```

## Pull Requests y fusión

Cada integrante abre un Pull Request desde su rama hacia `main`. El propietario
revisa que el autor y el archivo sean correctos y fusiona los tres Pull
Requests.

Después, en la VM y como `adminsys`:

```bash
cd /proyecto
git switch main
git pull --rebase
```

## Completar el README

El propietario reemplaza la fila pendiente del README por los datos ya
confirmados de Daniel. Después:

```bash
grep -n '^| 4 |' README.md
git diff -- README.md
git add README.md
git commit -m "docs: completar integrante 4 del equipo"
git push
```

## Verificación final de la Fase 3

Desde la VM:

```bash
cd /proyecto
git status --short --branch
git remote -v
git log --format='%h | %an | %s' --all
git log --format='%an' --all | sort -u
```

Deben aparecer cuatro autores:

- Carlos Enoc Calzada Vargas
- Azucena del Carmen Castillo Zepeda
- Ronie Odir Portillo Consuegra
- Josué Daniel Cruz Arce

Tomar la evidencia `F03_04_commits_integrantes.png`.

## Evidencias y snapshot

Copiar las evidencias finales de la Fase 3 desde el host a
`/proyecto/capturas/`, revisar `git status`, hacer el commit de evidencias y
subirlo. Finalmente crear el snapshot `03-git` de la VM `Debian 13`.

La Fase 3 termina cuando:

- los cuatro integrantes aparecen en el historial;
- el README ya no contiene datos pendientes;
- `main...origin/main` está limpio;
- las evidencias F03 están dentro de la VM y respaldadas;
- el snapshot `03-git` existe;
- `ESTADO_PROYECTO.md` marca la Fase 3 como completada.

La siguiente fase será la **Fase 4: Docker, servicio habilitado y prueba
`hello-world`**.

