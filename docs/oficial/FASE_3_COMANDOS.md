# Fase 3 — Control de versiones

> Proyecto Final ISL135 · Grupo 7 · VM `Debian 13`
>
> Ejecuta los bloques en orden. No avances si un punto de control no coincide con
> lo esperado. Las capturas se guardan en `/proyecto/capturas/` dentro de la VM y
> se respaldan en `revision-proyecto-isl135/evidencias/F03/` en el host.

## Estado de esta guía

- [x] Punto de control 1: prevalidación sin cambios
- [x] Punto de control 2: repositorio local e identidad
- [x] Punto de control 3: `.gitignore`, testigos y primer commit
- [x] Punto de control 4: repositorio remoto y primer `push`
- [x] Punto de control 5: `README.md` posterior al `push`
- [x] Punto de control 6: commits de los cuatro integrantes
- [x] Punto de control 7: snapshot `03-git`

## Evidencias de la fase

| Archivo | Contenido |
|---|---|
| `F03_00_preparacion.png` | Hostname, usuario, Git, estructura y ausencia de `.git` |
| `F03_01_git_local.png` | Repositorio inicializado, primer commit y `git log --graph` |
| `F03_02_remoto_push.png` | `git remote -v` y primer `push` exitoso |
| `F03_03_github.png` | Repositorio de GitHub mostrando los archivos |
| `F03_04_commits_integrantes.png` | Historial con commits de los cuatro integrantes |
| `F03_05_snapshot.png` | Snapshot `03-git` en VirtualBox |

No se debe incluir ninguna contraseña, token ni clave privada en una captura.

## Punto de control 1 — Prevalidación sin cambios

### 1. En el terminal del host: conectar a la VM

Comprueba que la VM correcta está encendida:

```bash
VBoxManage list runningvms
```

Debe aparecer `"Debian 13"` y una dirección UUID. Si el comando no imprime
nada, significa que no hay ninguna VM encendida; no es un error del comando.
Guarda esa pantalla como diagnóstico `F03_00a_vm_no_iniciada.png` y comprueba
que la VM sigue registrada:

```bash
VBoxManage list vms
```

Debe aparecer `"Debian 13"`. Enciéndela sin interfaz gráfica:

```bash
VBoxManage startvm "Debian 13" --type headless
```

Verifica el arranque:

```bash
VBoxManage list runningvms
```

Ahora debe aparecer `"Debian 13"` con su UUID. Guarda esta comprobación como
`F03_00b_vm_iniciada.png`. Después, abre la sesión SSH:

```bash
ssh -F /dev/null -p 2222 debian@127.0.0.1
```

Si la ventana de VirtualBox muestra `[Corriendo]` aunque
`VBoxManage list runningvms` no muestre nada en el terminal, la VM ya está
encendida. No ejecutes `startvm` de nuevo: guarda evidencia
`F03_00b_vm_encendida_grafica.png` y continúa directamente por SSH. Si el título
indica `00-base-instalada` o un snapshot anterior, la prevalidación debe
comprobar si `/proyecto` contiene las fases 1 y 2 antes de inicializar Git.

### 2. Dentro de la VM: comprobar hostname y entrar como `adminsys`

```bash
hostname
su - adminsys
whoami
```

Resultado esperado:

```text
servidor-grupo7
adminsys
```

Si `whoami` no muestra `adminsys`, detente y no continúes.

### 3. Ejecutar la prevalidación de la Fase 3

Copia este bloque completo en la sesión de `adminsys`:

```bash
cd /proyecto || { echo "ERROR: /proyecto no existe"; exit 1; }

echo "== Ubicación y usuario =="
pwd
whoami

echo "== Git =="
if command -v git >/dev/null 2>&1; then
    git --version
else
    echo "Git no está instalado (se instalará en el siguiente bloque)"
fi

echo "== Estructura obligatoria =="
for directorio in datos web scripts capturas; do
    if [ -d "/proyecto/$directorio" ]; then
        echo "OK: /proyecto/$directorio existe"
    else
        echo "ERROR: falta /proyecto/$directorio"
    fi
done

echo "== Propietarios y permisos =="
stat -c '%U:%G %a %n' \
    /proyecto \
    /proyecto/datos \
    /proyecto/web \
    /proyecto/scripts \
    /proyecto/capturas \
    /proyecto/scripts/reporte_sistema.sh

echo "== Estado del repositorio local =="
if [ -e /proyecto/.git ]; then
    echo "ATENCIÓN: /proyecto/.git ya existe; no se volverá a inicializar"
else
    echo "OK: /proyecto/.git todavía no existe"
fi

echo "== Archivos actuales (máximo dos niveles) =="
find /proyecto -maxdepth 2 -type f -printf '%P\n' | sort
```

### Resultado esperado

- `pwd` muestra `/proyecto`.
- `whoami` muestra `adminsys`.
- `git` responde con una versión, normalmente `git version 2.47.x`.
- Los cuatro directorios obligatorios existen.
- El script es ejecutable: `adminsys:adminsys 755` o equivalente.
- `/proyecto/.git` todavía no existe.
- Aparecen `reporte_sistema.sh` y las evidencias de fases anteriores.

### Evidencia `F03_00_preparacion.png`

Antes de escribir el siguiente comando, toma una captura del terminal del host
que incluya el comando de prevalidación y toda su salida. Guárdala inicialmente
en el host como:

```text
/home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/evidencias/F03/F03_00_preparacion.png
```

La copia definitiva deberá quedar también en `/proyecto/capturas/`.

## Cierre del primer bloque

No ejecutes todavía `git init`. Primero deben verificarse estas condiciones:

- la conexión es con `servidor-grupo7` y el usuario es `adminsys`;
- Git está instalado;
- `/proyecto` está completo y es accesible sin `sudo`;
- `/proyecto/.git` no existe;
- `F03_00_preparacion.png` fue guardada.

