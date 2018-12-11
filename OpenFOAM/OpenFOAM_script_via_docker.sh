# Script Install OpenFOAM via docker 
# Preparing installation
# Test in Deepin 15.8
# Autores: N.Torres
# jntorresr@udistrital.edu.co
# Version: 0.0.1
# Udpate: 12-10-2018

# Source info:
# OpenFOAM
# https://openfoam.org/download/6-linux/
# Docker
# https://docs.docker.com/compose/install/#install-compose
#Installing docker for debian
#Repositories Update
sudo apt-get -y update
#Download docker with curl 
curl -fsSL https://get.docker.com/ | sh
#Add user to docker group 
sudo usermod -aG docker $(whoami)
sudo chmod 666 /var/run/docker.sock
#OPTIONAL: Composer
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
docker-compose --version
sudo chmod +x /usr/local/bin/docker-compose
# OPTIONAL: Dockstation
wget https://github.com/DockStation/dockstation/releases/download/v1.4.1/dockstation_1.4.1_amd64.deb
sudo dpkg -i dockstation_1.4.1_amd64.deb
#sudo systemctl start docker.service
sudo service docker sttop
sudo service docker start 
#Installing OpenFOAM vía docker
#Download script docker Installing openfoam6-linux 
sudo sh -c "wget http://dl.openfoam.org/docker/openfoam6-linux -O /usr/bin/openfoam6-linux"
sudo chmod 755 /usr/bin/openfoam6-linux
#Launching OpenFOAM in linux
mkdir -p $HOME/OpenFOAM/${USER}-6
cd $HOME/OpenFOAM/${USER}-6
openfoam6-linux
#Testing OpenFOAM 
cd $FOAM_RUN
cp -r $FOAM_TUTORIALS/incompressible/simpleFoam/pitzDaily .
cd pitzDaily
blockMesh
simpleFoam
paraFoam