#!/usr/bin/env bash
#
# verificar_proyecto.sh - Verificación integral del proyecto ISL135
# Ejecutar como adminsys (con acceso a Docker) desde la VM:
#   /proyecto/scripts/verificar_proyecto.sh
#
# Devuelve 0 si todas las comprobaciones obligatorias pasan y 1 si hay fallos.
# No modifica el sistema ni los contenedores.
#
set -u

VERDE=$'\033[0;32m'
ROJO=$'\033[0;31m'
AMARILLO=$'\033[1;33m'
NC=$'\033[0m'

fallos=0
avisos=0

ok()    { printf '%s[OK]%s %s\n'    "$VERDE"    "$NC" "$*"; }
fallo() { printf '%s[FALLO]%s %s\n' "$ROJO"     "$NC" "$*"; fallos=$((fallos + 1)); }
aviso() { printf '%s[AVISO]%s %s\n' "$AMARILLO" "$NC" "$*"; avisos=$((avisos + 1)); }
info()  { printf '%s[INFO]%s %s\n'  "$AMARILLO" "$NC" "$*"; }

echo "=================================================="
echo " VERIFICACIÓN INTEGRAL - PROYECTO ISL135"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo " Host:  $(hostname)"
echo " Usuario: $(id -un)"
echo "=================================================="

if [[ "$(id -un)" != "adminsys" ]]; then
    aviso "Ejecuta como adminsys para comprobar Docker sin sudo; usuario actual: $(id -un)"
fi

# 1. Hostname
if [[ "$(hostname)" =~ ^servidor-grupo[0-9]+$ ]]; then
    ok "Hostname correcto: $(hostname)"
else
    fallo "Hostname inesperado: $(hostname) (se esperaba servidor-grupoN)"
fi

# 2. Usuarios y grupos
for u in adminsys tecnico visitante; do
    if id "$u" >/dev/null 2>&1; then
        ok "Existe el usuario $u"
    else
        fallo "Falta el usuario $u"
    fi
done

id -nG adminsys  2>/dev/null | grep -qw sudo    && ok "adminsys pertenece a sudo"    || fallo "adminsys no pertenece a sudo"
id -nG tecnico   2>/dev/null | grep -qw soporte && ok "tecnico pertenece a soporte"  || fallo "tecnico no pertenece a soporte"
id -nG visitante 2>/dev/null | grep -qw web     && ok "visitante pertenece a web"    || fallo "visitante no pertenece a web"

for u in adminsys tecnico; do
    id -nG "$u" 2>/dev/null | grep -qw docker \
        && ok "$u pertenece al grupo docker" \
        || fallo "$u no pertenece al grupo docker"
done

# 3. Directorios, grupo propietario y setgid
for d in datos web scripts capturas; do
    if [[ -d "/proyecto/$d" ]]; then
        ok "Existe /proyecto/$d"
    else
        fallo "Falta /proyecto/$d"
    fi
done

if [[ -w /proyecto ]]; then
    ok "El usuario actual puede escribir en /proyecto"
else
    fallo "El usuario actual no puede escribir en /proyecto"
fi

grupo_datos="$(stat -c '%G' /proyecto/datos 2>/dev/null || true)"
grupo_web="$(stat -c '%G' /proyecto/web 2>/dev/null || true)"
perm_datos="$(stat -c '%A' /proyecto/datos 2>/dev/null || true)"
perm_web="$(stat -c '%A' /proyecto/web 2>/dev/null || true)"

[[ "$grupo_datos" == "soporte" ]] && ok "datos: grupo soporte" || fallo "datos: grupo incorrecto ($grupo_datos)"
[[ "$grupo_web" == "web" ]]       && ok "web: grupo web"       || fallo "web: grupo incorrecto ($grupo_web)"
[[ "$perm_datos" == drwxrws* ]]   && ok "datos tiene setgid ($perm_datos)" || fallo "datos sin setgid ($perm_datos)"
[[ "$perm_web" == drwxrws* ]]     && ok "web tiene setgid ($perm_web)"     || fallo "web sin setgid ($perm_web)"

if [[ -f /proyecto/web/index.html ]]; then
    ok "Existe /proyecto/web/index.html"
else
    fallo "Falta /proyecto/web/index.html"
fi

if [[ -f /proyecto/Dockerfile ]]; then
    ok "Existe /proyecto/Dockerfile"
else
    fallo "Falta /proyecto/Dockerfile"
fi

# 4. Script de monitoreo
if [[ -x /proyecto/scripts/reporte_sistema.sh ]]; then
    ok "reporte_sistema.sh es ejecutable"

    salida_reporte="$(/proyecto/scripts/reporte_sistema.sh 2>&1)" || true
    for etiqueta in "REPORTE DEL SISTEMA" "Hostname" "Usuarios conectados" "Disco principal" "RAM disponible" "Contenedores Docker"; do
        if grep -Fq "$etiqueta" <<<"$salida_reporte"; then
            ok "El reporte contiene: $etiqueta"
        else
            fallo "El reporte no contiene: $etiqueta"
        fi
    done
else
    fallo "reporte_sistema.sh no existe o no es ejecutable"
fi

# 5. Cron y log
if [[ -f /etc/cron.d/proyecto ]]; then
    ok "Existe /etc/cron.d/proyecto"
    if grep -Eq '^[^#]*\*/30[[:space:]].*reporte_sistema\.sh' /etc/cron.d/proyecto; then
        ok "Cron programado cada 30 minutos"
    else
        fallo "Cron no contiene una entrada */30 para reporte_sistema.sh"
    fi
else
    fallo "Falta /etc/cron.d/proyecto"
fi

systemctl is-active --quiet cron && ok "Servicio cron activo" || fallo "Servicio cron inactivo"
systemctl is-enabled --quiet cron && ok "Servicio cron habilitado" || fallo "Servicio cron no habilitado"

log_cron="/var/log/proyecto/reporte_sistema.log"
if [[ -s "$log_cron" ]]; then
    ok "Log de cron con contenido ($(wc -l < "$log_cron") líneas)"
    if find "$log_cron" -mmin -35 -print -quit 2>/dev/null | grep -q .; then
        ok "Log actualizado en los últimos 35 minutos"
    else
        aviso "El log no se ha actualizado en los últimos 35 minutos"
    fi
else
    fallo "Log de cron vacío o ausente: $log_cron"
fi

# 6. Docker
if command -v docker >/dev/null 2>&1; then
    ok "Docker instalado: $(docker --version 2>/dev/null)"
    systemctl is-active --quiet docker && ok "Servicio docker activo" || fallo "Servicio docker inactivo"
    systemctl is-enabled --quiet docker && ok "Servicio docker habilitado" || fallo "Servicio docker no habilitado"

    if docker info >/dev/null 2>&1; then
        ok "El usuario actual puede usar Docker"

        if docker images --format '{{.Repository}}' | grep -Eq '^servidor-grupo[0-9]+$'; then
            ok "Existe una imagen servidor-grupoN"
        else
            fallo "No existe la imagen servidor-grupoN"
        fi
    else
        fallo "Sin acceso a Docker (revisa el grupo docker y vuelve a iniciar sesión)"
    fi
else
    fallo "Docker no está instalado"
fi

# 7. Contenedores, puertos, red y volumen
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    for c in nginx-basico nginx-personalizado nginx-red nginx-volumen; do
        if docker ps --format '{{.Names}}' | grep -qx "$c"; then
            ok "Contenedor activo: $c"
        else
            fallo "Contenedor no activo: $c"
        fi
    done

    mount_basico="$(docker inspect -f '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' nginx-basico 2>/dev/null || true)"
    mount_red="$(docker inspect -f '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' nginx-red 2>/dev/null || true)"
    mount_volumen="$(docker inspect -f '{{range .Mounts}}{{.Name}} -> {{.Destination}}{{"\n"}}{{end}}' nginx-volumen 2>/dev/null || true)"

    grep -Fq '/proyecto/web -> /usr/share/nginx/html' <<<"$mount_basico" \
        && ok "nginx-basico monta /proyecto/web" \
        || fallo "nginx-basico no monta /proyecto/web"
    grep -Fq '/proyecto/web -> /usr/share/nginx/html' <<<"$mount_red" \
        && ok "nginx-red monta /proyecto/web" \
        || aviso "nginx-red no monta /proyecto/web (no es obligatorio para la fase 7)"
    grep -Fq 'volumen-web -> /usr/share/nginx/html' <<<"$mount_volumen" \
        && ok "nginx-volumen usa volumen-web" \
        || fallo "nginx-volumen no usa volumen-web"

    for p in 8080 8081 8082 8083; do
        code="$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://localhost:$p" 2>/dev/null || echo '000')"
        [[ "$code" == "200" ]] && ok "http://localhost:$p -> 200" || fallo "http://localhost:$p -> $code"
    done

    docker network inspect red-proyecto >/dev/null 2>&1 \
        && ok "Red red-proyecto existe" \
        || fallo "Falta red red-proyecto"

    if docker inspect -f '{{json .NetworkSettings.Networks}}' nginx-red 2>/dev/null | grep -q 'red-proyecto'; then
        ok "nginx-red está conectado a red-proyecto"
    else
        fallo "nginx-red no está conectado a red-proyecto"
    fi

    docker volume inspect volumen-web >/dev/null 2>&1 \
        && ok "Volumen volumen-web existe" \
        || fallo "Falta volumen volumen-web"

    if docker exec nginx-volumen test -s /usr/share/nginx/html/index.html >/dev/null 2>&1; then
        ok "El volumen contiene index.html"
    else
        fallo "El volumen no contiene index.html"
    fi
fi

# 8. Git
if [[ -d /proyecto/.git ]]; then
    ok "Repositorio Git en /proyecto"

    if git -C /proyecto remote get-url origin >/dev/null 2>&1; then
        ok "Remoto origin: $(git -C /proyecto remote get-url origin)"
    else
        fallo "Sin remoto origin"
    fi

    if [[ -f /proyecto/README.md ]]; then
        ok "Existe README.md"
    else
        fallo "Falta README.md"
    fi

    if [[ -f /proyecto/.gitignore ]]; then
        ok "Existe .gitignore"
    else
        fallo "Falta .gitignore"
    fi

    estado_git="$(git -C /proyecto status --porcelain 2>/dev/null || true)"
    if [[ -z "$estado_git" ]]; then
        ok "Git sin cambios pendientes"
    else
        fallo "Git tiene cambios sin commitear"
        printf '%s\n' "$estado_git"
    fi

    autores="$(git -C /proyecto log --format='%an' 2>/dev/null | sed '/^$/d' | sort -u | wc -l)"
    if (( autores >= 4 )); then
        ok "Commits de $autores autores distintos"
    else
        fallo "Solo $autores autores distintos; se esperan al menos 4"
    fi

    if git -C /proyecto ls-files | grep -Eq '\.(ova|vdi|iso)$'; then
        fallo "El repositorio contiene una imagen de VM (OVA/VDI/ISO)"
    else
        ok "El repositorio no contiene OVA/VDI/ISO"
    fi

    info "Últimos commits:"
    git -C /proyecto log --oneline -5 2>/dev/null || true
else
    fallo "No hay repositorio Git en /proyecto"
fi

echo "=================================================="
if (( fallos == 0 )); then
    if (( avisos > 0 )); then
        printf '%sRESULTADO: todo lo obligatorio pasó, con %d aviso(s).%s\n' "$VERDE" "$avisos" "$NC"
    else
        printf '%sRESULTADO: todas las verificaciones pasaron.%s\n' "$VERDE" "$NC"
    fi
    exit 0
else
    printf '%sRESULTADO: %d verificación(es) con fallo.%s\n' "$ROJO" "$fallos" "$NC"
    exit 1
fi
