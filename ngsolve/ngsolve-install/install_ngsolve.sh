#!/usr/bin/env bash
# install_ngsolve.sh
#
# Orquestador de instalación de NGSolve. Soporta dos modos:
#   pip     -> instalación rápida vía pip (recomendada, todas las plataformas)
#   source  -> compilación desde fuente vía cmake/make (universal en Linux)
#
# Uso:
#   ./install_ngsolve.sh pip
#   ./install_ngsolve.sh source [BASEDIR]
#
# BASEDIR es opcional para el modo "source" (por defecto: $HOME/ngsolve)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-}"
BASEDIR="${2:-$HOME/ngsolve}"

usage() {
    echo "Uso: $0 {pip|source} [BASEDIR]"
    echo ""
    echo "  pip     Instala NGSolve vía pip (recomendado para la mayoría de casos)."
    echo "  source  Compila NGSolve desde fuente (universal, útil en Deepin u otras"
    echo "          distros no soportadas por los repositorios oficiales de NGSolve)."
    exit 1
}

install_via_pip() {
    echo "==> Instalando NGSolve vía pip..."
    if command -v pip3 >/dev/null 2>&1; then
        pip3 install --upgrade ngsolve
        pip3 install anywidget
    else
        pip install --upgrade ngsolve
        pip install anywidget
    fi
    echo "==> Instalación vía pip completada."
    echo "==> Verifica con: python3 -c 'import ngsolve; print(ngsolve.__version__)'"
}

install_via_source() {
    echo "==> Instalando NGSolve desde fuente en ${BASEDIR}..."
    bash "${SCRIPT_DIR}/scripts/check_dependencies.sh"
    bash "${SCRIPT_DIR}/scripts/build_ngsolve.sh" "${BASEDIR}"
    bash "${SCRIPT_DIR}/scripts/setup_environment.sh" "${BASEDIR}"
    echo "==> Instalación desde fuente completada."
    echo "==> Abre una terminal nueva (o haz 'source ~/.bashrc') y corre el test de validación."
}

case "${MODE}" in
    pip)
        install_via_pip
        ;;
    source)
        install_via_source
        ;;
    *)
        usage
        ;;
esac
