#!/usr/bin/env bash
set -euo pipefail

readonly DEFAULT_SOURCE_DIR="$HOME/code_saturne_src"
readonly DEFAULT_BUILD_DIR="$HOME/saturne_build"

log() {
    printf '%s\n' "$*"
}

warn() {
    printf '⚠ %s\n' "$*" >&2
}

die() {
    printf '✗ Error: %s\n' "$*" >&2
    exit 1
}

usage() {
    cat <<'EOF'
Uso:
  ./install_code_saturne.sh
  ./install_code_saturne.sh --help

Este script instala Code_Saturne desde un tarball local o desde una URL oficial.
EOF
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "Falta la herramienta '$1'. Instálala antes de continuar."
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

require_cmd wget
require_cmd tar
require_cmd python3

log "=========================================="
log "  Code_Saturne Installer v0.3.0"
log "=========================================="
log ""

# --- 1. Selección del archivo fuente ---
log "--- Selección de fuente ---"
read -r -p "¿Ya tiene un archivo .tar.gz localmente? (s/n): " has_file

case "$has_file" in
    s|S)
        read -r -p "Introduzca la ruta completa al archivo .tar.gz: " local_path
        if [[ "$local_path" == "~"* ]]; then
            local_path="${HOME}${local_path:1}"
        fi
        if [[ -f "$local_path" ]]; then
            tar_file_path="$(realpath "$local_path")"
            tar_file="$(basename "$tar_file_path")"
            target_dir="$(dirname "$tar_file_path")"
            log "✓ Usando archivo local: $tar_file"
            log "  Directorio de fuentes: $target_dir"
        else
            die "El archivo no existe en la ruta especificada: $local_path"
        fi
        ;;
    n|N)
        read -r -p "Introduzca la URL de descarga oficial: " tar_url
        if [[ ! "$tar_url" =~ ^https?:// ]]; then
            die "URL inválida. Debe comenzar con http:// o https://"
        fi
        read -r -p "Directorio de descarga y extracción [default: $DEFAULT_SOURCE_DIR]: " target_dir
        target_dir="${target_dir:-$DEFAULT_SOURCE_DIR}"
        mkdir -p "$target_dir"
        target_dir="$(realpath "$target_dir")"
        tar_file="$(basename "$tar_url")"
        tar_file_path="$target_dir/$tar_file"
        log "Descargando $tar_file..."
        wget -O "$tar_file_path" "$tar_url" || die "La descarga falló. Compruebe la URL o la conexión."
        log "✓ Archivo descargado: $tar_file"
        log "  Directorio de fuentes: $target_dir"
        ;;
    *)
        die "Respuesta inválida. Introduce s o n."
        ;;
esac

# --- 2. Extracción de origen ---
log ""
log "Extrayendo archivos..."
mkdir -p "$target_dir"
cd "$target_dir"
tar -xf "$tar_file_path"

extracted_dir="$(tar -tf "$tar_file_path" | sed '/^$/d' | head -n 1 | cut -d'/' -f1)"
if [[ -z "$extracted_dir" ]]; then
    die "No se pudo detectar el directorio extraído del tarball."
fi

source_dir="$target_dir/$extracted_dir"
if [[ ! -d "$source_dir" ]]; then
    die "El directorio extraído no existe: $source_dir"
fi

log "✓ Fuentes extraídas en: $source_dir"

# --- 3. Dependencias ---
log ""
log "Instalando dependencias necesarias (requiere sudo)..."
if ! command -v sudo >/dev/null 2>&1; then
    die "Se requiere sudo para instalar dependencias del sistema."
fi
sudo apt update
sudo apt install -y \
    pyqt5-dev-tools \
    python3-setuptools \
    build-essential \
    gfortran \
    libxml2-dev \
    zlib1g-dev \
    python3-pyqt5 \
    libopenmpi-dev || die "Fallo en la instalación de dependencias."

log "✓ Dependencias instaladas correctamente"

# --- 4. Directorio de compilación ---
log ""
log "--- Configuración del directorio de compilación ---"
read -r -p "Directorio donde se compilará Code_Saturne [default: $DEFAULT_BUILD_DIR]: " target_build_dir
target_build_dir="${target_build_dir:-$DEFAULT_BUILD_DIR}"
mkdir -p "$target_build_dir"
target_build_dir="$(realpath "$target_build_dir")"

if [[ "$target_build_dir" == "$target_dir"* ]]; then
    die "El directorio BUILD no puede estar dentro del directorio de fuentes. Elija otro directorio, por ejemplo: $DEFAULT_BUILD_DIR"
fi

log "✓ Directorio de compilación: $target_build_dir"

# --- 5. Fase 1: generación del setup ---
log ""
log "=========================================="
log "  FASE 1: Generación de configuración"
log "=========================================="

install_script="$source_dir/install_saturne.py"
if [[ ! -f "$install_script" ]]; then
    die "No se encontró install_saturne.py en $install_script"
fi

cd "$target_build_dir"
log "Generando archivo de configuración 'setup'..."
python3 "$install_script" || die "Fallo en la generación de setup."

if [[ -f "setup" ]]; then
    log "Configurando 'setup' para descarga automática de dependencias faltantes..."
    sed -i 's/download  no/download  yes/g' setup || die "No fue posible ajustar el archivo setup."
    log "✓ Archivo 'setup' configurado correctamente"
else
    die "No se pudo generar el archivo 'setup'."
fi

# --- 6. Fase 2: compilación real ---
log ""
log "=========================================="
log "  FASE 2: Compilación real"
log "=========================================="
log "Iniciando compilación. Esto puede tardar varios minutos..."
python3 "$install_script" || {
    warn "La compilación falló. Revisa los logs en: $target_build_dir"
    exit 1
}

log "✓ Compilación completada con éxito"

# --- 7. Binario y entorno ---
log ""
log "Configurando entorno y permisos..."
bin_path="$(find "$target_build_dir" -type f -name "code_saturne" -path "*/bin/*" | head -n 1 || true)"
if [[ -z "$bin_path" ]]; then
    bin_path="$(find "$target_build_dir" -type f -name "code_saturne" | head -n 1 || true)"
fi
if [[ -z "$bin_path" ]]; then
    die "No se encontró el binario code_saturne en $target_build_dir. Revisa los logs de compilación."
fi

bin_dir="$(dirname "$bin_path")"
if [[ ! -x "$bin_path" ]]; then
    chmod +x "$bin_path"
fi

if ! grep -q "$bin_dir" "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo "# Code_Saturne Paths (instalado por install_code_saturne.sh)" >> "$HOME/.bashrc"
    echo "export PATH=\$PATH:$bin_dir" >> "$HOME/.bashrc"
    echo "alias code_saturne=\"$bin_dir/code_saturne\"" >> "$HOME/.bashrc"
    log "✓ ~/.bashrc actualizado correctamente"
else
    log "✓ La ruta ya existe en ~/.bashrc; no se duplicará"
fi

log ""
log "=========================================="
log "  🎉 INSTALACIÓN COMPLETADA CON ÉXITO"
log "=========================================="
log ""
log "Información de instalación:"
log "  • Fuentes:        $source_dir"
log "  • Compilación:    $target_build_dir"
log "  • Binario:        $bin_path"
log "  • Directorio bin: $bin_dir"
log ""
log "Para empezar a usar Code_Saturne:"
log "  1. Ejecuta: source ~/.bashrc"
log "  2. Luego:   code_saturne"
log ""
log "O abre una nueva terminal y usa directamente:"
log "  code_saturne"
log ""
log "=========================================="