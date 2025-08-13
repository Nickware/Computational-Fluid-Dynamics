# **Guía de instalación de NGSolve**

Esta es una guía breve para instalar la biblioteca de elementos finitos de alto rendimiento **NGSolve** en distribuciones de 64 bits de Ubuntu y Fedora.

## **Ubuntu 64-bit (22.04 y posterior)**

NGSolve está disponible a través de Launchpad para Ubuntu. Sigue estos pasos para instalarlo:

1. Asegúrarse que el repositorio universe esté activo en tu sistema.  
   `sudo apt-add-repository universe`

2. Añadir el PPA de NGSolve. Por defecto, esto añadirá las versiones mensuales. Si prefiere las versiones de desarrollo (nightly builds), usa ppa:ngsolve/nightly en su lugar.  
   `sudo add-apt-repository ppa:ngsolve/ngsolve`

3. Actualizar lista de paquetes.  
   `sudo apt-get update`

4. Instalar NGSolve.  
   `sudo apt-get install ngsolve`

## **Fedora**

La instalación de NGSolve en Fedora se gestiona a través del sistema de paquetes RPM Fusion. Aquí están los pasos recomendados para instalarlo:

1. Habilitar el repositorio **RPM Fusion** en su sistema. Este paso es necesario si no lo ha hecho antes.  
   `sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm \-E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm \-E %fedora).noarch.rpm`

2. Instalar el paquete de NGSolve usando dnf.  
   `sudo dnf install ngsolve`  
