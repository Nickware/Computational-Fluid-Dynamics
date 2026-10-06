# Instalación de Elmer FEM

## Requisitos

- Ubuntu/Debian o sistema compatible con `apt-get`
- Git
- CMake
- gcc, g++, gfortran
- librerías de compilación y Qt5 para ElmerGUI

## Instalación rápida

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
bash scripts/install_elmer.sh
```

## Opciones útiles

```bash
bash scripts/install_elmer.sh --prefix /opt/Elmer
bash scripts/install_elmer.sh --build-dir /tmp/elmer-build
bash scripts/install_elmer.sh --skip-deps
```

## Validación

```bash
bash tests/validate_install.sh
```

## Después de la instalación

Recarga el entorno:

```bash
source ~/.bashrc
```

Prueba:

```bash
ElmerSolver -h
ElmerGrid -h
```
