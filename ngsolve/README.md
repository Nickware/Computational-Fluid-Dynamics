# Guía de instalación de NGSolve (multi-distro)

Esta guía cubre dos rutas de instalación de **NGSolve** que funcionan en
cualquier distribución Linux moderna (Ubuntu, Fedora, Debian, Deepin, etc.),
en lugar de depender de repositorios específicos como PPAs de Launchpad o
RPM Fusion. Incluye también un script automatizado (`install_ngsolve.sh`)
y un test de validación.

## Contenido de este repositorio

```
ngsolve-install/
├── README.md
├── install_ngsolve.sh          # Script orquestador principal
├── scripts/
│   ├── check_dependencies.sh   # Detecta apt/dnf e instala prerrequisitos
│   ├── build_ngsolve.sh        # Clona y compila NGSolve (cmake + make)
│   └── setup_environment.sh    # Configura NETGENDIR, PATH, PYTHONPATH
└── test/
    └── test_ngsolve.py         # Test de validación de la instalación
```

## Opción 1 — Instalación vía pip (recomendada)

Es la ruta más simple y la que el proyecto recomienda para todas las
plataformas, ya que no depende del gestor de paquetes del sistema operativo:

```bash
pip3 install --upgrade ngsolve
pip3 install anywidget   # opcional, para trabajar con Jupyter notebooks
```

O usando el script incluido:

```bash
./install_ngsolve.sh pip
```

## Opción 2 — Compilación desde fuente (universal)

Recomendada si necesitas una versión específica, si trabajas en una distro
sin repositorio oficial (como Deepin), o si quieres controlar las flags
de compilación.

### Prerrequisitos

En Linux se necesita: un compilador reciente, Python ≥3.8 (con paquetes
"dev"), tcl/tk ≥8.5 ("dev"), git, cmake ≥3.16, libxmu-dev (y posiblemente
xorg-dev), libglu ("dev") y liblapacke-dev.

Esto se resuelve automáticamente con:

```bash
bash scripts/check_dependencies.sh
```

El script detecta si el sistema usa `apt` (Debian/Ubuntu/Deepin) o `dnf`
(Fedora) e instala el paquete equivalente en cada caso.

### Estructura de directorios

La compilación usa tres carpetas dentro de un directorio base (`BASEDIR`,
por defecto `~/ngsolve`):

- `src/` — código fuente de NGSolve y sus submódulos (Netgen, Pybind11)
- `build/` — salida de cmake y del compilador
- `install/` — instalación final

### Clonado y compilación

```bash
bash scripts/build_ngsolve.sh ~/ngsolve
```

Internamente este script:

1. Clona `https://github.com/NGSolve/ngsolve.git` con submódulos.
2. Configura con `cmake ../src -DCMAKE_INSTALL_PREFIX=<install>`.
3. Compila e instala con `make -j<n> install`.

### Variables de entorno

```bash
bash scripts/setup_environment.sh ~/ngsolve
```

Esto añade a tu `~/.bashrc`:

- `NETGENDIR` apuntando al binario instalado.
- `PATH` extendido con `NETGENDIR`.
- `PYTHONPATH` apuntando al directorio de paquetes Python de NGSolve.

Después de correrlo, abre una terminal nueva o ejecuta `source ~/.bashrc`.

### Todo en un solo paso

```bash
./install_ngsolve.sh source ~/ngsolve
```

### Actualizar una instalación existente

El propio `build_ngsolve.sh` detecta si `src/` ya existe y, en ese caso,
hace `git pull` + `git submodule update --recursive --init` antes de
recompilar con `make install`.

## Test de validación

El archivo `test/test_ngsolve.py` resuelve un problema clásico de
elementos finitos — la ecuación de Poisson `-Δu = 1` en un cuadrado
unitario con condiciones de Dirichlet homogéneas — y compara el valor
máximo de la solución contra un valor de referencia conocido
(≈ 0.0736713).

Si la malla se genera, el sistema se ensambla y se resuelve, y el
resultado numérico coincide con la referencia, la instalación quedó
correctamente funcional de punta a punta (Netgen + NGSolve + solver).

### Cómo correrlo

```bash
python3 test/test_ngsolve.py
```

### Salida esperada

```
==> NGSolve importado correctamente.
==> Malla generada: XX elementos, YY vertices.
==> Valor maximo calculado de u: 0.073671
==> Valor de referencia esperado: 0.073671

>>> INSTALACION OK: la solucion coincide con el valor de referencia.
```

Un `ImportError` al inicio normalmente indica que `PYTHONPATH` no está
bien configurado (instalación desde fuente) o que el entorno virtual
activo no es el mismo donde se instaló NGSolve (instalación vía pip).

## Nota sobre Deepin

Deepin está basado en Debian, por lo que comparte `apt`, pero **no** es
Ubuntu: los PPAs de Launchpad no son compatibles de forma confiable en
Deepin porque están compilados contra las librerías del sistema de
Ubuntu. Por eso esta guía evita PPAs y RPM Fusion, y usa pip o
compilación desde fuente, que son agnósticas a la distro.
