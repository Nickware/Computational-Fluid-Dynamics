# Instalación de Elmer FEM

Esta guía está pensada para una instalación reproducible en Linux, preferiblemente en distribuciones basadas en Ubuntu/Debian.

## 1. Requisitos del sistema

Antes de instalar, verifica que tu sistema cumpla con estos requisitos:

- Ubuntu, Debian o derivado con `apt-get`
- acceso de administrador para instalar paquetes del sistema
- conexión a Internet para clonar el repositorio oficial de Elmer
- compilador GNU: `gcc`, `g++`, `gfortran`
- `git`, `make`, `cmake`
- librerías de Qt5 si quieres usar `ElmerGUI`

## 2. Descarga del repositorio

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics
git clone https://github.com/ElmerCSC/elmerfem /tmp/elmerfem
```

Si ya trabajas dentro del repositorio local del proyecto, puedes usar el instalador incluido:

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
bash scripts/install_elmer.sh
```

## 3. Instalación rápida

La forma recomendada dentro de este repositorio es:

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
bash scripts/install_elmer.sh
```

### Opciones útiles

```bash
bash scripts/install_elmer.sh --prefix /opt/Elmer
bash scripts/install_elmer.sh --build-dir /tmp/elmer-build
bash scripts/install_elmer.sh --repo-dir /tmp/elmerfem
bash scripts/install_elmer.sh --skip-deps
```

## 4. Recarga del entorno

Tras la instalación, recarga tu terminal:

```bash
source ~/.bashrc
```

Si no quieres reiniciar la sesión, también puedes exportar manualmente:

```bash
export ELMER_HOME=/opt/Elmer
export PATH="$PATH:$ELMER_HOME/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ELMER_HOME/lib"
```

## 5. Validación mínima de instalación

Ejecuta la validación incluida:

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
bash tests/validate_install.sh
```

La validación comprueba lo siguiente:

- que existen los comandos básicos del sistema,
- que `ELMER_HOME` apunta a un directorio válido, si está definido,
- que `ElmerSolver` y `ElmerGrid` están disponibles en el `PATH`,
- que el entorno está listo para ejecutar casos simples.

## 6. Comandos básicos para comprobar la instalación

```bash
ElmerSolver -h
ElmerGrid -h
ElmerGUI --help
```

Si los comandos no responden, revisa primero el `PATH` y vuelve a ejecutar:

```bash
source ~/.bashrc
```

## 7. Tutorial mínimo: caso de conducción en placa

El ejemplo más sencillo y útil para empezar es un problema 2D de conducción estacionaria.

### Objetivo

Resolver la ecuación de calor en una placa cuadrada con temperatura fija en un lado caliente y otro frío.

### Pasos básicos

1. Crear una malla 2D rectangular con Gmsh o cualquier generador aceptado.
2. Crear el caso en formato `.sif`.
3. Ejecutar:

```bash
ElmerGrid 14 2 placa.msh -out placa
ElmerSolver placa.sif
```

4. Visualizar resultados con ElmerGUI o Paraview.

Se recomienda observar:

- un gradiente térmico aproximadamente lineal,
- temperatura máxima en el borde caliente,
- temperatura mínima en el borde frío,
- condición de aislación en los lados laterales.

## 8. Solución de problemas frecuentes

### `ElmerSolver: command not found`

```bash
source ~/.bashrc
which ElmerSolver
```

### `Permission denied` al instalar

Comprueba que tienes permisos para escribir en `/opt` o cambia la ruta con `--prefix`.

### Error durante la compilación

Revisa dependencias con:

```bash
sudo apt-get install -y build-essential gfortran cmake git
```

## 9. Siguiente paso recomendado

Después de la instalación ya puedes continuar con:

- la guía de tutorial en [docs/TUTORIAL_HEAT_PLATE.md](TUTORIAL_HEAT_PLATE.md)
- la solución de problemas en [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- la validación automática en [tests/validate_install.sh](../tests/validate_install.sh)
