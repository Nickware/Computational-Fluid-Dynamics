#!/bin/bash
# Script to Install Docker, Docker Compose and OpenFOAM via Docker
# Tested on Debian-based systems (e.g., Deepin)
# Author: N. Torres 
# Version: 2025-08-31
# Sources:
# Docker https://docs.docker.com/engine/install/debian/
# Docker Compose https://docs.docker.com/compose/install/
# OpenFOAM https://openfoam.org/download/docker/

set -e

echo "Updating packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installing required packages for Docker..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting up the Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index again..."
sudo apt-get update -y

echo "Installing Docker Engine, CLI and containerd..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding current user to the docker group..."
sudo usermod -aG docker $USER

echo "Installing Docker Compose latest version..."
DOCKER_COMPOSE_VERSION=$(curl -fsSL https://github.com/docker/compose/releases/latest | grep -oP 'tag/\K[^\"]+')
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Verifying Docker and Docker Compose versions..."
docker --version
docker-compose --version

echo "Downloading OpenFOAM Docker launch script..."
sudo wget -q -O /usr/local/bin/openfoam6-linux https://dl.openfoam.org/docker/openfoam6-linux
sudo chmod +x /usr/local/bin/openfoam6-linux

echo "Setting up OpenFOAM working directory..."
mkdir -p $HOME/OpenFOAM/${USER}-6
cd $HOME/OpenFOAM/${USER}-6

echo "Launching OpenFOAM container..."
openfoam6-linux

echo "Running OpenFOAM test case..."
cd $FOAM_RUN
cp -r $FOAM_TUTORIALS/incompressible/simpleFoam/pitzDaily .
cd pitzDaily
blockMesh
simpleFoam
paraFoam

echo "OpenFOAM setup and test completed."
echo "Please log out and back in for docker group changes to take effect."
