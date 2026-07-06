# Instalación de OpenFOAM desde las fuentes

Este proyecto incluye un instalador en Bash que descarga automáticamente la última versión disponible de OpenFOAM desde `latest/`, resuelve las dependencias necesarias, compila **ThirdParty** y OpenFOAM, y deja el entorno listo para uso en Linux. El script está pensado para funcionar en Debian, Ubuntu, Deepin, Fedora, Red Hat y Arch Linux. [wiki.archlinux](https://wiki.archlinux.org/title/OpenFOAM)

## Requisitos

Antes de ejecutar el instalador, necesitas acceso a `sudo`, conexión a internet y una terminal compatible con Bash. El script también instala herramientas de compilación y, cuando está disponible, ParaView para facilitar la visualización con `paraFoam`. [dl.openfoam](https://dl.openfoam.com/source/)

## Qué hace el instalador

El script detecta la distribución Linux desde `/etc/os-release`, instala las dependencias correctas para cada familia de sistema y descarga la última versión de OpenFOAM disponible en el repositorio `latest/`. Luego extrae automáticamente el número de versión desde el nombre del paquete descargado y reutiliza esa misma versión en todas las rutas y pasos posteriores. [dl.openfoam](https://dl.openfoam.com/source/latest/)

## Instalación por distribución

### Debian, Ubuntu y Deepin
El instalador usa `apt-get` para actualizar el sistema e instalar compiladores, bibliotecas científicas, MPI, Qt, CGAL, Scotch, `flex`, `bison`, `curl`, `wget`, `git` y otras utilidades necesarias para compilar OpenFOAM. [wiki.archlinux](https://wiki.archlinux.org/title/OpenFOAM)

### Fedora, Red Hat y derivados
El instalador usa `dnf`, instala el grupo de desarrollo y agrega las bibliotecas equivalentes a las de Debian/Ubuntu, junto con `flex`, `bison`, `curl`, `wget`, `git` y ParaView cuando está disponible en los repositorios. [dl.openfoam](https://dl.openfoam.com/source/)

### Arch Linux
El instalador usa `pacman` con `--needed` para evitar reinstalaciones innecesarias y deja el entorno listo para compilar OpenFOAM desde fuente. [wiki.archlinux](https://wiki.archlinux.org/title/OpenFOAM)

## Descarga automática

El script consulta el directorio `latest/` del repositorio oficial de descargas y detecta los archivos `OpenFOAM-v*.tgz` y `ThirdParty-v*.tgz` más recientes. Esa detección permite evitar que la versión quede escrita “a mano” en el script, así el mismo archivo seguirá funcionando cuando salga una nueva release. [dl.openfoam](https://dl.openfoam.com/source/latest/)

## Configuración del entorno

Después de extraer los paquetes, el instalador agrega automáticamente a tu perfil de shell la línea necesaria para cargar OpenFOAM en futuras sesiones. En Bash escribe en `~/.bashrc`, y si usas Zsh puede adaptarse al archivo correspondiente; al iniciar una nueva terminal bastará con ejecutar `source $HOME/OpenFOAM/OpenFOAM-<version>/etc/bashrc`. [wiki.archlinux](https://wiki.archlinux.org/title/OpenFOAM)

## Compilación

El proceso compila primero **ThirdParty** y luego OpenFOAM, usando `./Allwmake -j` para aprovechar varios núcleos del procesador. Esto acelera la compilación y permite que las dependencias externas queden listas antes del núcleo principal de OpenFOAM. [wiki.archlinux](https://wiki.archlinux.org/title/OpenFOAM)

## Verificación de la instalación

Al final, el instalador ejecuta `foamInstallationTest -short` y prueba además la presencia de utilidades como `blockMesh`. Si ParaView está instalado, también podrás usar `paraFoam`; si no, la instalación de OpenFOAM puede seguir siendo válida, aunque la visualización gráfica dependerá de instalar ParaView aparte. [cfd-online](https://www.cfd-online.com/Forums/openfoam-installation/90537-foaminstallationtest.html)

## Paso a paso del test

Después de completar la instalación, puedes validar el entorno con un tutorial clásico como `pitzDaily`. Ese caso es muy usado como primera prueba porque confirma que la malla, el solver y la visualización funcionan correctamente. [cfd](https://cfd.ninja/openfoam/openfoam-first-tutorial-pitzdaily/)

### 1. Cargar el entorno

```bash
source $HOME/OpenFOAM/OpenFOAM-<version>/etc/bashrc
```

Esto activa las variables de OpenFOAM, incluyendo `FOAM_RUN` y `FOAM_TUTORIALS`. [cfd-online](https://www.cfd-online.com/Forums/openfoam-installation/90537-foaminstallationtest.html)

### 2. Ir al directorio de ejecución

```bash
mkdir -p $FOAM_RUN
cd $FOAM_RUN
```

OpenFOAM usa este directorio como espacio de trabajo para tus casos. [cfd](https://cfd.ninja/openfoam/openfoam-first-tutorial-pitzdaily/)

### 3. Copiar el tutorial

```bash
cp -r $FOAM_TUTORIALS/incompressible/simpleFoam/pitzDaily .
cd pitzDaily
```

Este tutorial representa un flujo estacionario incomprensible en un canal y es una prueba estándar para instalaciones nuevas. [github](https://github.com/konradmalik/openfoam211-docker)

### 4. Generar la malla

```bash
blockMesh
```

Este paso crea la malla del caso y confirma que la parte de preprocesamiento está funcionando. [cfd](https://cfd.ninja/openfoam/openfoam-first-tutorial-pitzdaily/)

### 5. Ejecutar el solver

```bash
simpleFoam
```

Con esto se corre el caso de flujo estacionario y se generan los resultados en carpetas de tiempo. [github](https://github.com/konradmalik/openfoam211-docker)

### 6. Visualizar resultados

```bash
touch pitzDaily.foam
paraFoam
```

Si ParaView está instalado y el entorno está bien configurado, se abrirá la interfaz gráfica para revisar campos y vectores de velocidad. [cfd-online](https://www.cfd-online.com/Forums/openfoam-installation/177354-docker-running-paraview-parafoam.html)

## Instalación vía Docker

Este proyecto también incluye una alternativa con Docker para quienes prefieren no compilar OpenFOAM localmente. En ese caso, primero se instala Docker Engine y Docker Compose, luego se descarga el script oficial de OpenFOAM para Docker y finalmente se corre un tutorial equivalente para comprobar el entorno. [youtube](https://www.youtube.com/watch?v=PJw5GZ3ghVY)

## Test en Docker

El caso de prueba recomendado sigue siendo `pitzDaily`, usando el mismo flujo de trabajo: `blockMesh`, `simpleFoam` y `paraFoam`. Si el entorno gráfico no está disponible, siempre puedes trabajar con el caso y luego exportar resultados para visualización externa. [ikespand.github](https://ikespand.github.io/posts/openfoam-docker-2024/)

## Notas finales

Si durante la instalación aparece el aviso de `No completions...`, normalmente significa que OpenFOAM todavía no ha sido compilado y puede ignorarse al inicio. En cambio, errores como `flex: not found` o `paraview: not found` sí indican dependencias faltantes que el instalador debe resolver. [ameblo](https://ameblo.jp/doctornova/entry-12651400661.html)
