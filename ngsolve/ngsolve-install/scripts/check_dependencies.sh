#!/usr/bin/env bash
# check_dependencies.sh
# Detecta el gestor de paquetes disponible (apt o dnf) e instala
# las dependencias necesarias para compilar NGSolve desde fuente.

set -euo pipefail

echo "==> Detectando sistema de paquetes..."

if command -v apt-get >/dev/null 2>&1; then
    echo "==> Detectado apt (Debian/Ubuntu/Deepin). Instalando dependencias..."
    sudo apt-get update
    sudo apt-get install -y \
        python3 python3-distutils python3-tk libpython3-dev \
        libxmu-dev tk-dev tcl-dev cmake git g++ \
        libglu1-mesa-dev liblapacke-dev \
        libocct-data-exchange-dev libocct-draw-dev occt-misc \
        libtbb-dev libxi-dev xorg-dev

elif command -v dnf >/dev/null 2>&1; then
    echo "==> Detectado dnf (Fedora). Instalando dependencias..."
    sudo dnf install -y \
        python3 python3-devel tk-devel tcl-devel \
        cmake git gcc-c++ \
        mesa-libGLU-devel lapack-devel \
        opencascade-devel tbb-devel libXi-devel libXmu-devel

else
    echo "ERROR: no se encontró apt-get ni dnf en este sistema." >&2
    echo "Instala manualmente las dependencias listadas en el README y vuelve a intentar." >&2
    exit 1
fi

echo "==> Dependencias instaladas correctamente."
