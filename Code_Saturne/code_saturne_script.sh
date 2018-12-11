# Script Install Code Saturne 
# Preparing installation and build Binaries
# Test in Deepin 15.8
# Autores: N.Torres
# jntorresr@udistrital.edu.co
# Version: 0.0.2
# Udpate: 12-10-2018

cd /tmp
wget http://code-saturne.org/cms/sites/default/files/releases/code_saturne-5.3.1.tar.gz
tar -xvf code_saturne-5.3.1.tar.gz
cd code_saturne-5.3.1
sudo apt install pyqt5-dev-tools
sudo mkdir /opt/code_saturne
# You must have previously installed Salome Meca
sudo ./configure --prefix=/opt/code_saturne --with-salome=/opt/Salome/Salome-edf/Salome-V8_5_0-univ_withOT --with-hdf5=salome --with-cgns=salome --with-med=salome QT_SELECT=5
sudo make -j4 
sudo make install