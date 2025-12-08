## Elmer FEM - Script de Instalación

Este repositorio contiene un script para la descarga, compilación e instalación de **Elmer FEM** a partir del código fuente, orientado a sistemas Linux. Elmer FEM es un software de elementos finitos para simulaciones multiphysicas.

### Resumen del Script

El script automatiza los siguientes pasos:

- Creación de un directorio temporal para la descarga y la compilación.
- Clonación del repositorio oficial de Elmer FEM.
- Configuración de la compilación con CMake, habilitando la GUI, el soporte para MPI y Paraview.
- Compilación e instalación en `/opt/Elmer`.
- Configuración de las variables de entorno necesarias para el uso de Elmer.


### Cambios y Actualizaciones Recomendadas

> **Nota:** El script original fue probado en Deepin 15.8 (2018). Desde entonces, han cambiado las versiones de las dependencias y las mejores prácticas de instalación. Ha de revisarse y actualizarse en los siguientes aspectos antes de usar el script en sistemas actuales.

#### 1. Versiones de Dependencias

- **CMake:** Usar versiones recientes (≥3.16) para una mejor compatibilidad.
- **Compiladores:** gcc y gfortran actualizados (≥9.0).
- **MPI:** Instalar `openmpi` o `mpich`, según la preferencia y la compatibilidad.
- **Qt y Qwt:** Verificar las versiones compatibles con la GUI de Elmer.
- **Paraview:** Instalar la versión recomendada por la documentación de Elmer.
- **BLAS y LAPACK:** Usar implementaciones optimizadas como `libopenblas-dev` o `liblapack-dev`.


#### 2. Instalación de Dependencias

Ejemplo para sistemas basados en Debian/Ubuntu:

```bash
sudo apt update
sudo apt install git cmake g++ gfortran libopenmpi-dev openmpi-bin qtbase5-dev libqwt-qt5-dev paraview libblas-dev liblapack-dev
```

> **Revisar los nombres de los paquetes** en otras distribuciones (como Fedora, Arch, etc.).

#### 3. Permisos

- La instalación en `/opt/Elmer` requiere permisos de superusuario.
- Se recomienda ejecutar el script con `sudo` o modificar el directorio de instalación a una ruta local si no se cuenta con los permisos de root.


#### 4. Personalización y Compatibilidad

- El script puede requerir ajustes para otras distribuciones de Linux.
- Revisar rutas y nombres de los paquetes según el sistema operativo.
- Considerar el uso de entornos virtuales o de contenedores (Docker) para mayor portabilidad.


#### 5. Variables de Entorno

Agregar las siguientes líneas al archivo `~/.bashrc` o `~/.profile` para que Elmer esté disponible en cada sesión:

```bash
export ELMER_HOME=/opt/Elmer/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ELMER_HOME/lib
export PATH=$PATH:$ELMER_HOME/bin
```


### Consideraciones Importantes

- **Dependencias:** Instalar todas las dependencias antes de ejecutar el script.
- **Permisos:** Algunas operaciones requieren permisos de superusuario.
- **Personalización:** Adaptar el script a la distribución y el entorno de trabajo.


### Para Futuras Versiones

- Actualizar el script para detectar automáticamente las versiones de las dependencias y sugerir instalaciones.
- Añadir soporte para la instalación en entornos virtuales o en contenedores.
- Mejorar la gestión de errores y de mensajes informativos.
- Documentar la compatibilidad con nuevas versiones de Elmer y sus dependencias.

**Contribuciones y mejoras son bienvenidas.**

