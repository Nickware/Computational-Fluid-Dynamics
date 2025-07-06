## Elmer FEM - Script de Instalación

Este repositorio contiene un script para la descarga, compilación e instalación de **Elmer FEM** desde el código fuente, orientado a sistemas Linux. Elmer FEM es un software de elementos finitos para simulaciones multiphysicas.

### Resumen del Script

El script automatiza los siguientes pasos:

- Creación de un directorio temporal para la descarga y compilación.
- Clonación del repositorio oficial de Elmer FEM.
- Configuración de la compilación con CMake, habilitando la GUI, soporte para MPI y Paraview.
- Compilación e instalación en `/opt/Elmer`.
- Configuración de variables de entorno necesarias para el uso de Elmer.


### Cambios y Actualizaciones Recomendadas

> **Nota:** El script original fue probado en Deepin 15.8 (2018). Desde entonces, han cambiado versiones de dependencias y mejores prácticas de instalación. Ha de ser revisado y actualizado bajo los siguientes aspectos antes de usar el script en sistemas actuales.

#### 1. Versiones de Dependencias

- **CMake:** Usar versiones recientes (≥3.16) para mejor compatibilidad.
- **Compiladores:** gcc y gfortran actualizados (≥9.0).
- **MPI:** Instalar `openmpi` o `mpich` según preferencia y compatibilidad.
- **Qt y Qwt:** Verificar versiones compatibles con la GUI de Elmer.
- **Paraview:** Instalar la versión recomendada por la documentación de Elmer.
- **BLAS y LAPACK:** Usar implementaciones optimizadas como `libopenblas-dev` o `liblapack-dev`.


#### 2. Instalación de Dependencias

Ejemplo para sistemas basados en Debian/Ubuntu:

```bash
sudo apt update
sudo apt install git cmake g++ gfortran libopenmpi-dev openmpi-bin qtbase5-dev libqwt-qt5-dev paraview libblas-dev liblapack-dev
```

> **Revisar los nombres de los paquetes** en otras distribuciones (Fedora, Arch, etc.).

#### 3. Permisos

- La instalación en `/opt/Elmer` requiere permisos de superusuario.
- Se recomienda ejecutar el script con `sudo` o modificar el directorio de instalación a una ruta local si no se tienen permisos de root.


#### 4. Personalización y Compatibilidad

- El script puede necesitar ajustes para otras distribuciones Linux.
- Revisar rutas y nombres de paquetes según el sistema operativo.
- Considerar el uso de entornos virtuales o contenedores (Docker) para mayor portabilidad.


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
- **Personalización:** Adaptar el script según la distribución y entorno de trabajo.


### Para Futuras Versiones

- Actualizar el script para detectar automáticamente versiones de dependencias y sugerir instalaciones.
- Añadir soporte para instalación en entornos virtuales o contenedores.
- Mejorar la gestión de errores y mensajes informativos.
- Documentar compatibilidad con nuevas versiones de Elmer y dependencias.

**Autores:**
N. Torres
jntorresr@udistrital.edu.co

**Última actualización del script original:** 12-10-2018

**Contribuciones y mejoras son bienvenidas.**

