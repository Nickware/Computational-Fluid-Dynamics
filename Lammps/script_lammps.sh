# Requeriments Install 
sudo apt-get install libvtk7-dev
# add in Makefile.lammps VTK
# vtk_SYSINC = -I/usr/include/vtk-7.1
# vtk_SYSLIB = -lvtkCommonCore-7.1 -lvtkIOCore-7.1 -lvtkIOXML-7.1 -lvtkIOLegacy-7.1 -lvtkCommonDataModel-7.1 -lvtkIOParallelXML-7.1
# vtk_SYSPATH = -L/usr/lib/x86_64-linux-gnu
# Build auxiliary libraries for LAMMPS
make yes-granular yes-user-vtk yes-dump mpi
