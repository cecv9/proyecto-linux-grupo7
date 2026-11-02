#!/usr/bin/env bash
#
# organizar_capturas_vm.sh
# Reorganiza /proyecto/capturas por fases, igual que el repositorio Git.
#
# Uso (dentro de la VM, como adminsys):
#   cd /proyecto
#   git pull
#   chmod +x scripts/organizar_capturas_vm.sh
#   ./scripts/organizar_capturas_vm.sh
#
# El script hace un respaldo antes de mover nada.

set -euo pipefail

BASE="/proyecto/capturas"

if [[ ! -d "$BASE" ]]; then
  echo "ERROR: no existe $BASE"
  exit 1
fi

BACKUP="/proyecto/capturas_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp -a "$BASE"/. "$BACKUP"/ 2>/dev/null || true
echo "Respaldo creado en: $BACKUP"

declare -A DEST=(
  [F00]="fase-00-preparacion"
  [F01]="fase-01-administracion-basica"
  [F02]="fase-02-automatizacion-monitoreo"
  [F03]="fase-03-control-versiones"
  [F04]="fase-04-docker"
  [F05]="fase-05-nginx-basico"
  [F06]="fase-06-imagen-personalizada"
  [F07]="fase-07-redes-volumenes"
  [F08]="fase-08-pruebas-verificacion"
)

for folder in "${DEST[@]}"; do
  mkdir -p "$BASE/$folder"
done

move_one() {
  local src="$1"
  local dest="$2"
  local name
  name="$(basename "$src")"
  if [[ -e "$BASE/$dest/$name" ]]; then
    echo "AVISO: ya existe $dest/$name; se omite"
  else
    mv "$src" "$BASE/$dest/"
    echo "Movido: $name -> $dest/"
  fi
}

move_pattern() {
  local pattern="$1"
  local dest="$2"
  shopt -s nullglob
  for file in "$BASE"/$pattern; do
    [[ -f "$file" ]] || continue
    move_one "$file" "$dest"
  done
  shopt -u nullglob
}

# Evidencias sueltas en la raíz de capturas.
move_pattern 'F00_*' "fase-00-preparacion"
move_pattern '_F00_*' "fase-00-preparacion"
move_pattern 'F01_*' "fase-01-administracion-basica"
move_pattern 'F02_*' "fase-02-automatizacion-monitoreo"
move_pattern 'F03_*' "fase-03-control-versiones"
move_pattern 'F04_*' "fase-04-docker"
move_pattern 'F05_*' "fase-05-nginx-basico"
move_pattern 'F06_*' "fase-06-imagen-personalizada"
move_pattern 'F07_*' "fase-07-redes-volumenes"
move_pattern 'F08_*' "fase-08-pruebas-verificacion"

# Carpetas antiguas F04..F08.
for old in F04 F05 F06 F07 F08; do
  src="$BASE/$old"
  [[ -d "$src" ]] || continue
  dest="${DEST[$old]}"
  shopt -s nullglob
  for file in "$src"/*; do
    [[ -f "$file" ]] || continue
    move_one "$file" "$dest"
  done
  shopt -u nullglob
  rmdir "$src" 2>/dev/null || true
done

# Aviso si quedan archivos sueltos.
shopt -s nullglob
leftovers=("$BASE"/*.png "$BASE"/*.jpg "$BASE"/*.jpeg "$BASE"/*.txt)
shopt -u nullglob

echo
echo "Resumen:"
for folder in "${DEST[@]}"; do
  count=$(find "$BASE/$folder" -maxdepth 1 -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.txt' \) 2>/dev/null | wc -l)
  printf '  %-32s %s evidencias\n' "$folder" "$count"
done

if (( ${#leftovers[@]} > 0 )); then
  echo
  echo "Quedan archivos sueltos en $BASE:"
  printf '  %s\n' "${leftovers[@]}"
fi

echo
echo "Listo. Revisa los README.md de cada fase y luego:"
echo "  git -C /proyecto status --short"
echo "  git -C /proyecto add capturas"
echo "  git -C /proyecto commit -m 'docs: organizar capturas por fase en la VM'"
