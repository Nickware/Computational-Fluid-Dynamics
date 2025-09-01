#!/bin/bash
# Script to Install OpenFOAM via binaries and build from source
# Supports Debian, Ubuntu, Deepin (Debian-based), Fedora, Red Hat, Arch Linux
# Author: N. Torres (updated 2025 by AI Assistant)
# Version: 2025-08-31

set -e

echo "Detecting Linux distribution..."
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$ID
else
  echo "Cannot detect distribution. Exiting."
  exit 1
fi

echo "Updating system and installing dependencies..."

case $DISTRO in
  debian|ubuntu|deepin)
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y build-essential flex bison cmake zlib1g-dev \
      libboost-system-dev libboost-thread-dev libopenmpi-dev openmpi-bin \
      gnuplot libreadline-dev libncurses-dev libxt-dev qtbase5-dev qttools5-dev \
      libqt5x11extras5-dev libqt5help5 qtdeclarative5-dev libqt5webkit5 libqt5opengl5-dev \
      freeglut3-dev texinfo libscotch-dev libcgal-dev python3 python3-dev wget git
    ;;
  fedora|rhel|centos)
    sudo dnf update -y
    sudo dnf groupinstall "Development Tools" -y
    sudo dnf install -y flex bison cmake zlib-devel boost-devel openmpi-devel \
      gnuplot readline-devel ncurses-devel libXt-devel qt5-qtbase-devel \
      qt5-qtx11extras-devel qt5-qttools-devel qt5-qtsvg-devel freeglut-devel \
      scotch-devel CGAL-devel python3 python3-devel git wget
    ;;
  arch)
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm base-devel flex bison cmake zlib boost openmpi gnuplot \
      readline ncurses libxt qt5-base qt5-x11extras qt5-tools freeglut scotch cgal python git wget
    ;;
  *)
    echo "Distribution $DISTRO not supported by this script."
    exit 1
    ;;
esac

echo "Creating OpenFOAM working directory..."
mkdir -p $HOME/OpenFOAM

cd $HOME/OpenFOAM

echo "Downloading OpenFOAM source (latest stable release)..."
# Adjust to latest stable version here, example uses v2206:
OPENFOAM_VER="v2206"
if [ ! -d "OpenFOAM-$OPENFOAM_VER" ]; then
  wget https://dl.openfoam.com/source/$OPENFOAM_VER/OpenFOAM-$OPENFOAM_VER.tgz
  tar -xvf OpenFOAM-$OPENFOAM_VER.tgz
fi

echo "Downloading ThirdParty source..."
if [ ! -d "ThirdParty-$OPENFOAM_VER" ]; then
  wget https://dl.openfoam.com/source/$OPENFOAM_VER/ThirdParty-$OPENFOAM_VER.tgz
  tar -xvf ThirdParty-$OPENFOAM_VER.tgz
fi

echo "Setting environment variables in shell profile..."
SHELL_PROFILE="$HOME/.bashrc"
if [[ $SHELL == *zsh ]]; then
  SHELL_PROFILE="$HOME/.zshrc"
fi

grep -q "source \$HOME/OpenFOAM/OpenFOAM-$OPENFOAM_VER/etc/bashrc" $SHELL_PROFILE || \
  echo "source \$HOME/OpenFOAM/OpenFOAM-$OPENFOAM_VER/etc/bashrc" >> $SHELL_PROFILE

echo "Loading OpenFOAM environment for build..."
source $HOME/OpenFOAM/OpenFOAM-$OPENFOAM_VER/etc/bashrc

echo "Building ThirdParty dependencies..."
cd $HOME/OpenFOAM/ThirdParty-$OPENFOAM_VER
./Allwmake -j

echo "Building OpenFOAM source..."
cd $HOME/OpenFOAM/OpenFOAM-$OPENFOAM_VER
./Allwmake -j

echo "Build complete. Testing OpenFOAM installation..."
foamInstallationTest -short

echo "To start using OpenFOAM in future sessions, run:"
echo "source $HOME/OpenFOAM/OpenFOAM-$OPENFOAM_VER/etc/bashrc"

echo "OpenFOAM installation and build finished successfully."
