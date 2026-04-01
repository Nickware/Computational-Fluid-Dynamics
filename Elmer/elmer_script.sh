# Script Install Elmer
# Preparing installation and build Binaries
# Test in Deepin 25.0
# Autores: N.Torres
# jntorresr@udistrital.edu.co
# Version: 2.0
# Udpate: 31-03-2023

#!/bin/bash
set -e  # Salir ante cualquier error

TEMP_DIR="/tmp/elmer"
ELMER_DIR="$TEMP_DIR/elmerfem"
INSTALL_DIR="/opt/Elmer"

echo "=== Instalador Elmer FEM ==="

# 0. Instalar dependencias automáticamente
echo "Instalando dependencias requeridas..."
if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y \
    git cmake build-essential gfortran \
    libopenmpi-dev openmpi-bin \
    libblas-dev liblapack-dev \
    qtbase5-dev qttools5-dev libqwt-qt5-dev \
    qtscript5-dev libqt5script5 \
    libqt5svg5-dev \
    libgl1-mesa-dev libxt-dev
else
    echo "ERROR: Este script de auto-instalación está preparado para sistemas basados en Debian/Ubuntu con apt."
    exit 1
fi

# 1. Verificar herramientas básicas
echo "Verificando herramientas básicas..."
for cmd in git cmake make; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: '$cmd' no está instalado."
        exit 1
    fi
done

# 2. Verificar compiladores (CRÍTICO para Elmer)
echo "Verificando compiladores..."
for cmd in gcc g++ gfortran; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Compilador '$cmd' no está instalado."
        echo "Revisa la instalación automática de dependencias."
        exit 1
    fi
done

# 3. Crear directorios
echo "Preparando directorios..."
mkdir -p "$TEMP_DIR"
sudo mkdir -p "$INSTALL_DIR"
cd "$TEMP_DIR"

# 4. Repositorio Git (clone o update)
echo "Manejando repositorio..."
if [ ! -d "$ELMER_DIR" ]; then
    echo "Clonando ElmerFEM..."
    git clone https://github.com/ElmerCSC/elmerfem "$ELMER_DIR"
elif [ -d "$ELMER_DIR/.git" ]; then
    echo "Actualizando repositorio (rama devel)..."
    cd "$ELMER_DIR"
    git checkout devel
    git pull origin devel
else
    echo "ERROR: $ELMER_DIR existe pero no es repo Git válido."
    exit 1
fi

# 5. Configurar con CMake usando build separado
echo "Configurando con CMake..."
BUILD_DIR="$TEMP_DIR/build"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake \
    -DWITH_ELMERGUI:BOOL=TRUE \
    -DWITH_PARAVIEW:BOOL=TRUE \
    -DWITH_MPI:BOOL=TRUE \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
    "$ELMER_DIR"

# 6. Compilar e instalar
echo "Compilando (puede tomar 30+ minutos)..."
make -j"$(nproc)"
sudo make install

# 7. Variables de entorno
echo "Configurando variables de entorno..."
if ! grep -q 'ELMER_HOME=/opt/Elmer' ~/.bashrc 2>/dev/null; then
cat >> ~/.bashrc <<EOF

# Elmer FEM
export ELMER_HOME=$INSTALL_DIR
export PATH=\$PATH:\$ELMER_HOME/bin
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ELMER_HOME/lib
export MANPATH=\$MANPATH:\$ELMER_HOME/share/man
EOF
fi

echo ""
echo "INSTALACIÓN COMPLETADA"
echo "Reinicia tu terminal o ejecuta: source ~/.bashrc"
echo "Para probar: ElmerGUI"
