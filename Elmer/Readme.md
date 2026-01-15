# Elmer CSC

Elmer es un software de simulación multifísica de código abierto, desarrollado principalmente por el CSC – IT Center for Science de Finlandia[1][2][3]. Está diseñado para resolver problemas complejos mediante el método de elementos finitos (FEM), lo que lo hace especialmente útil en ingeniería y ciencias aplicadas.

## Características principales de Elmer

- Permite modelar y resolver ecuaciones diferenciales parciales asociadas a fenómenos físicos como:
  - Mecánica de sólidos y estructuras
  - Transferencia de calor
  - Electromagnetismo
  - Dinámica de fluidos
  - Acústica, entre otros[1][5][6]

- Es multiplataforma: funciona en sistemas Unix, GNU/Linux, Windows y Mac[1][5].
- Está compuesto por varios módulos, entre los que destacan:
  - **ElmerGUI**: interfaz gráfica para la definición de modelos y condiciones de contorno.
  - **ElmerSolver**: el núcleo que realiza los cálculos numéricos.
  - **ElmerPost**: herramienta para visualizar y analizar los resultados.
  - **ElmerGrid**: para la creación y manipulación de mallas[1][5][6].

- Es software libre y de código abierto, distribuido bajo licencia GPL, lo que permite su uso, modificación y distribución sin costo[1][2][6].
- Dispone de documentación extensa, tutoriales y una comunidad activa de usuarios[5][6].

## Aplicaciones

Elmer es ampliamente utilizado en investigación, educación y la industria para simular y analizar problemas donde intervienen múltiples fenómenos físicos acoplados. Su capacidad de integración con otras herramientas y formatos de malla lo hace versátil para distintos flujos de trabajo en ingeniería y ciencia[1][3][5].

## Comparación con otros programas

Elmer se compara con otros softwares de elementos finitos, tanto comerciales (como ANSYS o Matlab PDETool) como de código abierto (OpenFEM, FreeFem++), destacando por su gratuidad y flexibilidad[1].

Elmer es una potente herramienta de simulación numérica para problemas multifísicos, ideal tanto para el aprendizaje como para la investigación y el desarrollo profesional en ingeniería y ciencias aplicadas[2][3][5].

[1](https://es.wikipedia.org/wiki/Elmer_FEM_solver)
[2](https://edutools.tec.mx/es/colecciones/tecnologias/elmer)
[3](https://www.elmerfem.org/blog/)
[4](https://www.youtube.com/watch?v=4Ijcb0aMcig)
[5](https://dspace.ups.edu.ec/bitstream/123456789/9004/1/UPS-CT001707.pdf)
[6](https://www.dma.uvigo.es/files/cursos/elmerfem/Sesion3UDC.pdf)
[7](https://www.cfd-online.com/Wiki/ELMER)
[8](https://www.elmerfem.org/blog/general/elmer-version-8-4/)
[9](https://sv.linkedin.com/in/leomarqz)

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

