#!/usr/bin/env bash
# build_ngsolve.sh
# Clona el repositorio de NGSolve, inicializa submódulos, y compila
# usando cmake + make dentro de la estructura src/build/install.

set -euo pipefail

BASEDIR="${1:-$HOME/ngsolve}"
SRC_DIR="${BASEDIR}/src"
BUILD_DIR="${BASEDIR}/build"
INSTALL_DIR="${BASEDIR}/install"

echo "==> Directorio base: ${BASEDIR}"
mkdir -p "${SRC_DIR}" "${BUILD_DIR}" "${INSTALL_DIR}"

if [ -d "${SRC_DIR}/.git" ]; then
    echo "==> El código fuente ya existe, actualizando..."
    cd "${SRC_DIR}"
    git pull
    git submodule update --recursive --init
else
    echo "==> Clonando NGSolve y submódulos (Netgen, Pybind11)..."
    git clone --recurse-submodules https://github.com/NGSolve/ngsolve.git "${SRC_DIR}"
    cd "${SRC_DIR}"
    git submodule update --init --recursive
fi

echo "==> Configurando con cmake..."
cd "${BUILD_DIR}"
cmake "${SRC_DIR}" -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}"

echo "==> Compilando e instalando (esto puede tardar varios minutos)..."
NPROC="$(nproc 2>/dev/null || echo 2)"
make -j"${NPROC}" install

echo "==> Compilación finalizada. NGSolve instalado en: ${INSTALL_DIR}"
echo "${INSTALL_DIR}" > "${BASEDIR}/.install_path"
