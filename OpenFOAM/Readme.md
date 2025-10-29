# Instalación de Openfom desde las fuentes

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

# Instalacióm de Openfoam via Docker

Este script automatiza la instalación de Docker, Docker Compose y la ejecución de OpenFOAM vía contenedores Docker en sistemas basados en Debian, como Deepin, Ubuntu y similares. Su objetivo principal es facilitar la configuración rápida de un entorno CFD moderno y portátil sin necesidad de compilar manualmente ni instalar dependencias complejas, aprovechando las tecnologías de contenedores.[1][2]

***

### Actualización e instalación de dependencias básicas
El proceso comienza actualizando el sistema y asegurando que estén presentes utilidades esenciales como `curl`, `gnupg` y certificados raíz. Estas herramientas son necesarias para añadir repositorios oficiales y descargar archivos de manera segura.[1]

***

### Instalación segura de Docker Engine
El script crea la carpeta de llaves, importa la firma oficial de Docker y configura el repositorio de acuerdo a la arquitectura del sistema y la versión de la distribución. Después actualiza el índice de paquetes y finalmente instala Docker Engine, su CLI y containerd (el runtime para contenedores).[2][1]

- Usa los últimos métodos recomendados por Docker para añadir el repositorio y verificar la integridad.
- Habilita y arranca el servicio Docker automáticamente.
- Añade el usuario actual al grupo `docker` permitiendo ejecutar contenedores sin privilegios de root (tras reiniciar sesión).

***

### Instalación dinámica de Docker Compose
Detecta automáticamente la última versión disponible de Docker Compose directamente desde GitHub y la instala en `/usr/local/bin`. Esto evita la obsolescencia del gestor de orquestación de contenedores, permitiendo manejar compuestos y servicios multi-contenedor con las últimas características.[3]

***

### Verificación de versiones y prueba del entorno
Se verifica la instalación mostrando las versiones de Docker y Docker Compose, asegurando que ambos estén correctamente instalados y accesibles desde la terminal.[3]

***

### Instalación y ejecución de OpenFOAM mediante Docker
Descarga el script launcher oficial de OpenFOAM para Docker y lo coloca en `/usr/local/bin` con permisos de ejecución. Crea una carpeta de trabajo personalizada y lanza el contenedor de OpenFOAM con ese script.

- Evita conflictos de instalación y dependencias, ya que todo se ejecuta dentro de un contenedor encapsulado.
- La ejecución es compatible tanto con simulaciones interactivas como en batch.

***

### Prueba con tutorial CFD
Tras lanzar el contenedor, el script crea un entorno de trabajo y ejecuta un caso tutorial clásico (`pitzDaily`) usando comandos básicos de OpenFOAM:

- `blockMesh`: genera la malla del dominio.
- `simpleFoam`: corre el solver de flujo estacionario.
- `paraFoam`: abre resultados para post-procesamiento visual.

Esto valida que la instalación y el entorno Docker están completamente funcionales.

***

### Ventajas y observaciones
- El usuario solo necesita Docker, sin instalar ni compilar decenas de librerías científicas y dependencias.
- OpenFOAM se ejecuta aislado y reproducible, facilitando la portabilidad y eliminación de conflictos entre versiones.
- Al finalizar, el script recuerda al usuario salir y entrar de sesión para que el grupo `docker` tome efecto.[2][1]

Este enfoque es ideal para investigadores, estudiantes y profesionales que buscan rapidez, facilidad, y portabilidad al instalar OpenFOAM en sistemas Linux modernos mediante Docker.[1][2][3]

[1](https://docs.docker.com/engine/install/debian/)
[2](https://cloudhpc.cloud/2024/08/26/run-openfoam-with-docker/)
[3](https://dev.to/abbazs/how-to-install-the-latest-docker-and-docker-compose-on-debian-based-linux-systems-3o9j)
