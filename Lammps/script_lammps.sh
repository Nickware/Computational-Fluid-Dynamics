#!/bin/bash
# LAMMPS + VTK Installation Script (Improved)
# Requires: Ubuntu/Debian, sudo privileges

set -e  # Exit on error

echo "=== LAMMPS + VTK Installation Script ==="

# 1. Update system
echo "[1/7] Updating package lists..."
sudo apt-get update -qq

# 2. Install base dependencies
echo "[2/7] Installing base dependencies..."
sudo apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    gfortran \
    libfftw3-dev \
    libgomp1 \
    libopenmpi-dev \
    openmpi-bin \
    libvtk9-dev \
    vtk9 \
    git \
    curl

# 3. Verify VTK installation
echo "[3/7] Verifying VTK installation..."
VTK_VERSION=$(dpkg -l | grep libvtk9-dev | awk '{print $3}')
if [ -z "$VTK_VERSION" ]; then
    echo "ERROR: VTK 9 not found. Please install manually."
    exit 1
fi
echo "✓ VTK version: $VTK_VERSION"

# 4. Clone LAMMPS (stable version)
echo "[4/7] Cloning LAMMPS..."
if [ ! -d "lammps" ]; then
    git clone --branch stable --depth 1 https://github.com/LAMMPS/lammps.git
fi
cd lammps

# 5. Enable packages
echo "[5/7] Enabling LAMMPS packages..."
make yes-granular
make yes-user-vtk
make yes-dump
make yes-mpi

# 6. Configure with CMake
echo "[6/7] Configuring with CMake..."
mkdir -p build && cd build
cmake -C ../cmake/presets/most.cmake \
    -D BUILD_SHARED_LIBS=yes \
    -D CMAKE_BUILD_TYPE=Release \
    -D PKG_GRANULAR=yes \
    -D PKG_USER_VTK=yes \
    -D PKG_DUMP=yes \
    -D VTK_DIR=/usr/lib/x86_64-linux-gnu/cmake/vtk-9.0 \
    ..

# 7. Build and install
echo "[7/7] Building LAMMPS..."
make -j$(nproc)
sudo make install

echo "=== Installation Complete ==="
echo "Test LAMMPS: lmp -locktype none -in ../examples/airebo/in.airebo"
