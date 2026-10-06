#!/usr/bin/env bash
set -Eeuo pipefail

# Instalador robusto para Elmer FEM.
# Compatible con Debian/Ubuntu y con ejecuciones en entornos locales de Linux.

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ELMER_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly DEFAULT_PREFIX="/opt/Elmer"
readonly DEFAULT_BUILD_DIR="/tmp/elmer-build"
readonly DEFAULT_REPO_DIR="/tmp/elmerfem"

INSTALL_PREFIX="${ELMER_PREFIX:-${DEFAULT_PREFIX}}"
BUILD_DIR="${ELMER_BUILD_DIR:-${DEFAULT_BUILD_DIR}}"
REPO_DIR="${ELMER_REPO_DIR:-${DEFAULT_REPO_DIR}}"

usage() {
  cat <<EOF
Uso: bash scripts/install_elmer.sh [opciones]

Opciones:
  --prefix PATH      Ruta de instalación (por defecto: /opt/Elmer)
  --build-dir PATH   Directorio de compilación (por defecto: /tmp/elmer-build)
  --repo-dir PATH    Directorio del repositorio local (por defecto: /tmp/elmerfem)
  --skip-deps        No instala dependencias del sistema
  --help             Muestra esta ayuda
EOF
}

SUDO=""
SKIP_DEPS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prefix)
      INSTALL_PREFIX="${2:-}"
      shift 2
      ;;
    --build-dir)
      BUILD_DIR="${2:-}"
      shift 2
      ;;
    --repo-dir)
      REPO_DIR="${2:-}"
      shift 2
      ;;
    --skip-deps)
      SKIP_DEPS=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Opción no reconocida: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "${INSTALL_PREFIX}" ]]; then
  echo "ERROR: La ruta de instalación no puede estar vacía." >&2
  exit 1
fi

if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  SUDO=""
fi

require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: Falta la herramienta '$cmd' en el sistema." >&2
    exit 1
  fi
}

ensure_root_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    if [[ -n "$SUDO" ]]; then
      "$SUDO" mkdir -p "$dir"
    else
      mkdir -p "$dir"
    fi
  fi
}

install_dependencies() {
  if [[ "${SKIP_DEPS}" -eq 1 ]]; then
    echo "INFO: Se omite la instalación de dependencias (--skip-deps)."
    return
  fi

  if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: Este instalador está preparado para sistemas con apt-get (Debian/Ubuntu)." >&2
    exit 1
  fi

  echo "==> Instalando dependencias del sistema..."
  if [[ -n "$SUDO" ]]; then
    "$SUDO" apt-get update
    "$SUDO" apt-get install -y \
      git cmake build-essential gfortran \
      libopenmpi-dev openmpi-bin \
      libblas-dev liblapack-dev \
      qtbase5-dev qttools5-dev libqwt-qt5-dev \
      qtscript5-dev libqt5script5 \
      libqt5svg5-dev libgl1-mesa-dev libxt-dev
  else
    apt-get update
    apt-get install -y \
      git cmake build-essential gfortran \
      libopenmpi-dev openmpi-bin \
      libblas-dev liblapack-dev \
      qtbase5-dev qttools5-dev libqwt-qt5-dev \
      qtscript5-dev libqt5script5 \
      libqt5svg5-dev libgl1-mesa-dev libxt-dev
  fi
}

setup_environment() {
  local env_block
  env_block=$(cat <<EOF

# Elmer FEM
export ELMER_HOME="${INSTALL_PREFIX}"
export PATH="\$PATH:${INSTALL_PREFIX}/bin"
export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:${INSTALL_PREFIX}/lib"
export MANPATH="\$MANPATH:${INSTALL_PREFIX}/share/man"
EOF
)

  local bashrc="${HOME}/.bashrc"
  if ! grep -q 'ELMER_HOME=' "$bashrc" 2>/dev/null; then
    echo "==> Añadiendo variables de entorno a ${bashrc}"
    printf '%s\n' "$env_block" >> "$bashrc"
  else
    echo "INFO: Las variables de entorno de Elmer ya estaban configuradas."
  fi
}

clone_or_update_repo() {
  if [[ ! -d "${REPO_DIR}/.git" ]]; then
    echo "==> Clonando ElmerFEM en ${REPO_DIR}"
    rm -rf "${REPO_DIR}"
    git clone --branch devel https://github.com/ElmerCSC/elmerfem "${REPO_DIR}"
    return
  fi

  echo "==> Actualizando el repositorio Elmer en ${REPO_DIR}"
  git -C "${REPO_DIR}" fetch --all --tags
  git -C "${REPO_DIR}" checkout devel
  git -C "${REPO_DIR}" pull --ff-only origin devel
}

build_and_install() {
  ensure_root_dir "$(dirname "${INSTALL_PREFIX}")"

  if [[ -n "$SUDO" ]]; then
    "$SUDO" mkdir -p "${INSTALL_PREFIX}"
  else
    mkdir -p "${INSTALL_PREFIX}"
  fi

  echo "==> Configurando compilación con CMake"
  mkdir -p "${BUILD_DIR}"
  cmake -S "${REPO_DIR}" -B "${BUILD_DIR}" \
    -DWITH_ELMERGUI:BOOL=TRUE \
    -DWITH_PARAVIEW:BOOL=TRUE \
    -DWITH_MPI:BOOL=TRUE \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"

  echo "==> Compilando Elmer FEM..."
  cmake --build "${BUILD_DIR}" --parallel "$(nproc)"

  echo "==> Instalando Elmer FEM en ${INSTALL_PREFIX}"
  if [[ -n "$SUDO" ]]; then
    "$SUDO" cmake --install "${BUILD_DIR}"
  else
    cmake --install "${BUILD_DIR}"
  fi
}

validate_installation() {
  echo "==> Validando instalación básica"
  require_command ElmerSolver
  require_command ElmerGrid

  if command -v ElmerSolver >/dev/null 2>&1; then
    ElmerSolver -h >/dev/null 2>&1 || true
  fi

  if command -v ElmerGrid >/dev/null 2>&1; then
    ElmerGrid -h >/dev/null 2>&1 || true
  fi

  if command -v ElmerGUI >/dev/null 2>&1; then
    echo "INFO: ElmerGUI está disponible." 
  else
    echo "INFO: ElmerGUI no está en PATH pero el instalador puede haberlo omitido por dependencias del sistema."
  fi

  echo "OK: La instalación base de Elmer FEM se ha validado con comandos mínimos."
}

main() {
  echo "=== Instalador robusto de Elmer FEM ==="
  echo "Ruta de instalación: ${INSTALL_PREFIX}"
  echo "Directorio de compilación: ${BUILD_DIR}"
  echo "Repositorio: ${REPO_DIR}"

  install_dependencies
  require_command git
  require_command cmake
  require_command make
  require_command gcc
  require_command g++
  require_command gfortran

  clone_or_update_repo
  build_and_install
  setup_environment
  validate_installation

  echo ""
  echo "INSTALACIÓN COMPLETADA"
  echo "Recarga tu terminal con: source ~/.bashrc"
  echo "Prueba rápida: ElmerSolver -h"
}

main "$@"
