#!/usr/bin/env bash
# =====================================================
# DATA PROJECT CREATOR (BASH) - Works in WSL/Win/mac/Linux
# - En WSL + carpeta en /mnt/c => crea venv de WINDOWS (python.exe)
# - En otros casos => venv Linux/mac (bin/python)
# - Usa Python 3.11 si está disponible y registra el kernel de Jupyter
# =====================================================

set -euo pipefail

die()  { echo -e "\n❌ $*" >&2; exit 1; }
step() { echo -e "\n👉 $*"; }

[[ $EUID -eq 0 ]] && die "No ejecutes esto con sudo/root."

# Detectar WSL
is_wsl=false
case "$(uname -r | tr '[:upper:]' '[:lower:]')" in
  *microsoft*|*wsl*) is_wsl=true ;;
esac

# ---------- Rutas prohibidas ----------
is_prohibited_path() {
  local raw="${1%/}"
  local path
  path="$(realpath -m "$raw" 2>/dev/null || echo "$raw")"
  local lower="${path,,}"

  if $is_wsl; then
    case "$lower" in
      /) return 0 ;;
      /bin|/bin/*|/etc|/etc/*|/usr|/usr/*|/var|/var/*|/lib|/lib/*) return 0 ;;
      /mnt/c/windows|/mnt/c/windows/*) return 0 ;;
      /mnt/c/program\ files|/mnt/c/program\ files/*|/mnt/c/program\ files\ \(x86\)|/mnt/c/program\ files\ \(x86\)/*) return 0 ;;
      /mnt/c/users/administrator|/mnt/c/users/administrator/*|/mnt/c/users/public|/mnt/c/users/public/*) return 0 ;;
      *) return 1 ;;
    esac
  else
    case "$lower" in
      /|/bin|/bin/*|/etc|/etc/*|/usr|/usr/*|/var|/var/*|/lib|/lib/*|/system|/system/*|/volumes|/volumes/*) return 0 ;;
      *) return 1 ;;
    esac
  fi
}

# ---------- Prompts ----------
read -rp "📁 Base path: " base_path
[[ -z "$base_path" ]] && die "Ruta vacía."
is_prohibited_path "$base_path" && die "Ruta prohibida/sistema."
[[ ! -d "$base_path" ]] && die "La ruta no existe."

read -rp "📌 Project name (letters, numbers, '-', '_'): " project_name
[[ -z "$project_name" ]] && die "Nombre vacío."
[[ ! $project_name =~ ^[A-Za-z0-9_-]+$ ]] && die "Nombre inválido."

project_path="$base_path/$project_name"

# cleanup si falla
cleanup() {
  echo -e "\n⚠️ Error, limpiando '$project_path'..."
  rm -rf "$project_path"
}
trap cleanup ERR

# ---------- Estructura ----------
step "Creando estructura..."
folders=( ".venv" "data/raw" "data/processed" "data/external" "docs" "notebooks" "src" "outputs/figures" "outputs/powerbi_dashboard" )
for f in "${folders[@]}"; do mkdir -p "$project_path/$f"; done

files=( "requirements_devs.txt" "requirements_final.txt" "README.md" "data_dictionary.md" )
for f in "${files[@]}"; do [[ -f "$project_path/$f" ]] || touch "$project_path/$f"; done

cd "$project_path"

# ---------- Git ----------
step "Inicializando git..."
git init -b main >/dev/null 2>&1 || git init >/dev/null
cat > .gitignore <<'EOGIT'
# .gitignore
.venv/
__pycache__/
data/
outputs/powerbi_dashboard/
requirements_devs.txt
*.pbix
EOGIT

# ---------- Crear venv ----------
if $is_wsl && [[ "$project_path" == /mnt/c/* ]]; then
  # WSL + C: => VENV Windows
  step "Creando venv de Windows (python.exe)..."
  win_proj_path="$(wslpath -w "$project_path")"
  if powershell.exe -NoProfile -Command "py -3.11 -V" >/dev/null 2>&1; then
    py_cmd='py -3.11'
  elif powershell.exe -NoProfile -Command "py -3 -V" >/dev/null 2>&1; then
    py_cmd='py -3'
  else
    die "No se encontró 'py' en Windows. Instala Python 3.11 en Windows."
  fi

  powershell.exe -NoProfile -Command "$py_cmd -m venv '$win_proj_path\\.venv'" >/dev/null
  win_py="$project_path/.venv/Scripts/python.exe"
  [[ -f "$win_py" ]] || die "No se creó python.exe en .venv/Scripts"

  "$win_py" -m pip install -U pip ipykernel
  "$win_py" -m ipykernel install --user --name "$project_name" --display-name "Python ($project_name)" || true

  cat > requirements_devs.txt <<'EOREQ'
pandas>=2.2.3
numpy>=1.26.4
matplotlib>=3.8.3
jupyterlab>=4.1.6
notebook>=7.1.3
seaborn>=0.13.0
openpyxl>=3.1.2
xlrd>=2.0.1
xlsxwriter>=3.1.9
EOREQ

  read -rp "⚙️  Instalar dependencias ahora? (y/N): " yn
  yn="${yn,,}"
  if [[ "$yn" == "y" || "$yn" == "yes" ]]; then
    step "Instalando dependencias (Windows)..."
    "$win_py" -m pip install -r requirements_devs.txt
  else
    echo "→ Saltado. Luego: .venv\\Scripts\\pip install -r requirements_devs.txt"
  fi
else
  # Linux/mac/WSL en home => VENV Linux
  step "Creando venv Linux/mac (python 3.11 si existe)..."
  PYBIN="$(command -v python3.11 || command -v python3 || command -v python || true)"
  [[ -z "$PYBIN" ]] && die "No hay Python. Instálalo."

  "$PYBIN" -c "import venv, ensurepip" 2>/dev/null || die "Falta módulo venv/ensurepip. En Ubuntu: sudo apt install python3-venv"

  "$PYBIN" -m venv --copies .venv
  [[ -x ".venv/bin/python" ]] || die "Venv falló: falta .venv/bin/python"

  source ".venv/bin/activate"
  python -m pip install -U pip ipykernel
  python -m ipykernel install --user --name "$project_name" --display-name "Python ($project_name)" >/dev/null 2>&1 || true

  cat > requirements_devs.txt <<'EOREQ'
pandas>=2.2.3
numpy>=1.26.4
matplotlib>=3.8.3
jupyterlab>=4.1.6
notebook>=7.1.3
seaborn>=0.13.0
openpyxl>=3.1.2
xlrd>=2.0.1
xlsxwriter>=3.1.9
EOREQ

  read -rp "⚙️  Instalar dependencias ahora? (y/N): " yn
  yn="${yn,,}"
  if [[ "$yn" == "y" || "$yn" == "yes" ]]; then
    step "Instalando dependencias (Linux)..."
    pip install -r requirements_devs.txt
  else
    echo "→ Saltado. Luego: pip install -r requirements_devs.txt"
  fi
  deactivate || true
fi

# Permisos amigables para borrar en Windows
if $is_wsl && [[ "$project_path" == /mnt/c/* ]]; then
  find "$project_path" -type d -exec chmod 775 {} + 2>/dev/null || true
  find "$project_path" -type f -exec chmod 664 {} + 2>/dev/null || true
fi

trap - ERR
echo -e "\n🎉 Proyecto '$project_name' creado en: $project_path"
echo "   • Kernel: Python ($project_name)"
