#Script Install Elmer 
#Prepara la configuración de Elmer
#Construye los binarios de Elmer
#Probado en Deepin 15.7
#Autores: N.Torres
#jntorresr@udistrital.edu.co
#Version: 0.0.1
#Fecha: 12-11-2018
# https://ngsolve.org/docu/latest/install/installlinux.html
# https://ngsolve.org/docu/latest/install/cmakeoptions.html?highlight=opencascade

# Create directory temp where to download things
$ mkdir /tmp/elmer
$ cd /tmp/elmer

# clone the git repository.
git clone git://www.github.com/ElmerCSC/elmerfem

# Building the code
# create build directory
$ mkdir /opt/Elmer
$ cd /opt/Elmer

# let the cmake generate makefiles
$ sudo cmake -DWITH_ELMERGUI:BOOL=TRUE -DWITH_PARAVIEW:BOOL=TRUE -DWITH_MPI:BOOL=TRUE -DCMAKE_INSTALL_PREFIX=/opt/Elmer /tmp/elmerfem

# Cmake configures things, if it does not find something (e.g., lapack), you can help it by 
#$ cmake -DCMAKE_PREFIX_PATH=<path_to_lapack_installation> ../elmerfem

# Compile in parallel (4 procs) 
$ make -j4 install

Setting environmental variables
$ Written to file ~/.bashrc).

export ELMER_HOME=$HOME/elmer/install/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ELMER_HOME/lib
export PATH=$PATH:$ELMER_HOME/bin