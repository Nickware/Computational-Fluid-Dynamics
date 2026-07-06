#!/bin/bash
# Script to Install OpenFOAM via binaries and build from source
# Supports Debian, Ubuntu, Deepin (Debian-based), Fedora, Red Hat, Arch Linux
# Author: N. Torres (updated 2025 by AI Assistant)
# Version: 2025-08-31

#!/usr/bin/env bash
set -euo pipefail

OF_DIR="$HOME/OpenFOAM"
LATEST_URL="https://dl.openfoam.com/source/latest/"
PROFILE_FILE="$HOME/.bashrc"

log() { echo -e "\n==> $*"; }

detect_distro() {
  if [ ! -f /etc/os-release ]; then
    echo "No se pudo detectar la distribución."
    exit 1
  fi
  . /etc/os-release
  echo "${ID:-unknown}"
}

install_deps_debian() {
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install -y \
    build-essential flex bison cmake zlib1g-dev \
    libboost-system-dev libboost-thread-dev libopenmpi-dev openmpi-bin \
    gnuplot libreadline-dev libncurses-dev libxt-dev \
    qtbase5-dev qttools5-dev libqt5x11extras5-dev libqt5help5 \
    qtdeclarative5-dev libqt5webkit5 libqt5opengl5-dev freeglut3-dev \
    texinfo libscotch-dev libcgal-dev python3 python3-dev wget git curl \
    paraview
}

install_deps_fedora() {
  sudo dnf update -y
  sudo dnf groupinstall -y "Development Tools"
  sudo dnf install -y \
    flex bison cmake zlib-devel boost-devel openmpi-devel \
    gnuplot readline-devel ncurses-devel libXt-devel \
    qt5-qtbase-devel qt5-qtx11extras-devel qt5-qttools-devel qt5-qtsvg-devel \
    freeglut-devel scotch-devel CGAL-devel python3 python3-devel wget git curl \
    paraview
}

install_deps_arch() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm \
    base-devel flex bison cmake zlib boost openmpi gnuplot \
    readline ncurses libxt qt5-base qt5-x11extras qt5-tools freeglut \
    scotch cgal python git wget curl paraview
}

install_deps() {
  distro="$(detect_distro)"
  case "$distro" in
    debian|ubuntu|deepin) install_deps_debian ;;
    fedora|rhel|centos) install_deps_fedora ;;
    arch) install_deps_arch ;;
    *) echo "Distribución no soportada: $distro"; exit 1 ;;
  esac
}

get_latest_names() {
  local html of_tgz tp_tgz
  html="$(curl -fsSL "$LATEST_URL")"
  of_tgz="$(printf '%s' "$html" | grep -oE 'OpenFOAM-v[0-9]+\.tgz' | head -n 1)"
  tp_tgz="$(printf '%s' "$html" | grep -oE 'ThirdParty-v[0-9]+\.tgz' | head -n 1)"

  if [ -z "${of_tgz:-}" ] || [ -z "${tp_tgz:-}" ]; then
    echo "No se pudo detectar la última versión desde latest/."
    exit 1
  fi

  OPENFOAM_VER="$(echo "$of_tgz" | sed -E 's/OpenFOAM-(v[0-9]+)\.tgz/\1/')"
  THIRD_VER="$(echo "$tp_tgz" | sed -E 's/ThirdParty-(v[0-9]+)\.tgz/\1/')"

  if [ "$OPENFOAM_VER" != "$THIRD_VER" ]; then
    echo "La versión de OpenFOAM y ThirdParty no coincide."
    exit 1
  fi

  OPENFOAM_TGZ="$of_tgz"
  THIRD_TGZ="$tp_tgz"
}

download_sources() {
  mkdir -p "$OF_DIR"
  cd "$OF_DIR"

  if [ ! -d "OpenFOAM-$OPENFOAM_VER" ]; then
    log "Descargando OpenFOAM-$OPENFOAM_VER"
    wget -q "$LATEST_URL$OPENFOAM_TGZ"
    tar -xvf "$OPENFOAM_TGZ"
  fi

  if [ ! -d "ThirdParty-$OPENFOAM_VER" ]; then
    log "Descargando ThirdParty-$OPENFOAM_VER"
    wget -q "$LATEST_URL$THIRD_TGZ"
    tar -xvf "$THIRD_TGZ"
  fi
}

write_profile() {
  local line="source \$HOME/OpenFOAM/OpenFOAM-$OPENFOAM_VER/etc/bashrc"
  grep -qxF "$line" "$PROFILE_FILE" || echo "$line" >> "$PROFILE_FILE"
}

build_thirdparty() {
  log "Compilando ThirdParty-$OPENFOAM_VER"
  bash -lc "source '$OF_DIR/OpenFOAM-$OPENFOAM_VER/etc/bashrc' && cd '$OF_DIR/ThirdParty-$OPENFOAM_VER' && ./Allwmake -j"
}

build_openfoam() {
  log "Compilando OpenFOAM-$OPENFOAM_VER"
  bash -lc "source '$OF_DIR/OpenFOAM-$OPENFOAM_VER/etc/bashrc' && cd '$OF_DIR/OpenFOAM-$OPENFOAM_VER' && ./Allwmake -j"
}

test_install() {
  log "Verificando instalación"
  bash -lc "source '$OF_DIR/OpenFOAM-$OPENFOAM_VER/etc/bashrc' && foamInstallationTest -short" || true
  bash -lc "source '$OF_DIR/OpenFOAM-$OPENFOAM_VER/etc/bashrc' && which blockMesh && blockMesh -help >/dev/null"
  if command -v paraview >/dev/null 2>&1; then
    log "ParaView detectado"
  else
    log "ParaView no detectado; paraFoam puede no abrir GUI, pero OpenFOAM puede estar bien instalado"
  fi
}

main() {
  install_deps
  get_latest_names
  download_sources
  write_profile
  build_thirdparty
  build_openfoam
  test_install
  echo
  echo "Instalación finalizada."
  echo "Versión detectada: OpenFOAM-$OPENFOAM_VER"
  echo "Para cargarlo en nuevas terminales:"
  echo "source \$HOME/OpenFOAM/OpenFOAM-$OPENFOAM_VER/etc/bashrc"
}

main "$@"
