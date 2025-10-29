# Instalacióm de Openfom desde las fuentes

Instalación automatizada en bash sirve para descargar, compilar y preparar OpenFOAM desde fuentes en cualquier sistema Linux moderno (Debian, Ubuntu, Deepin, Fedora, Red Hat, Arch). Garantiza la instalación de todas las dependencias y configura el entorno de usuario, optimizando la experiencia de quienes requieren OpenFOAM compilado directamente en sus equipos.[1][2][3][4]

***

### Identificación y preparación del sistema
El script comienza detectando automáticamente la distribución del sistema usando `/etc/os-release`, lo que permite adaptar los comandos de instalación de paquetes según cada familia Linux. Si no logra identificar la distribución, termina con un mensaje de error.[4][1]

***

### Instalación de dependencias según distribución
Utiliza el gestor de paquetes adecuado para cada distribución, instalando todas las bibliotecas requeridas para compilar OpenFOAM:
- **Debian/Ubuntu/Deepin**: `apt-get` instala paquetes de desarrollo, MPI, Boost, Qt, Python, CGAL, Scotch, y herramientas científicas como Gnuplot y Texinfo.
- **Fedora/Red Hat/CentOS**: `dnf` utiliza grupos de desarrollo e instala los equivalentes en RPM.
- **Arch Linux**: `pacman` instala las dependencias con la opción `--needed` para evitar duplicados.
Esto asegura que todos los componentes nativos y científicos necesarios para OpenFOAM (y sus herramientas de post-proceso) estén presentes.[2][3][1]

***

### Descarga y descompresión de OpenFOAM
El script crea una carpeta `OpenFOAM` en el directorio del usuario, descarga la última versión estable (ejemplo: v2206) y el paquete “ThirdParty” con dependencias adicionales. Los archivos se descomprimen automáticamente, evitando duplicados si ya existen en la carpeta.[1][4]

***

### Configuración automática del entorno
Modifica el archivo de perfil del shell (por defecto `.bashrc`, con soporte para `.zshrc` si el usuario emplea Zsh) añadiendo el comando `source .../OpenFOAM-v2206/etc/bashrc`. Esto configura todas las variables de entorno de OpenFOAM para futuras sesiones del usuario, evitando la necesidad de recordar el comando manualmente.[1]

***

### Compilación de ThirdParty y OpenFOAM
Ejecuta los scripts de compilación (`./Allwmake -j`), utilizando todos los núcleos del sistema para acelerar el proceso. Primero compila las dependencias externas y luego OpenFOAM, permitiendo una instalación controlada y adaptada a cada sistema.[3][1]

***

### Verificación y uso posterior
Al finalizar, corre `foamInstallationTest -short` para comprobar que la instalación fue exitosa. Además, recuerda al usuario cómo cargar OpenFOAM en futuras sesiones y avisa que la instalación terminó correctamente.[4][1]

***

### Resumiendo
Este script está diseñado para facilitar y automatizar el proceso complejo de instalar OpenFOAM desde fuentes en cualquier distribución principal de Linux, resolviendo automáticamente dependencias, configurando el entorno y validando la instalación al final. Es especialmente útil para usuarios académicos, investigadores o profesionales que requieren control completo sobre su entorno CFD y máxima compatibilidad con sus sistemas.[2][3][4][1]

[1](https://openfoam.org/download/source/)
[2](https://openfoam.org/version/fedora/)
[3](https://wiki.archlinux.org/title/OpenFOAM)
[4](https://help.sim-flow.com/installation/linux/openfoam-installation)
