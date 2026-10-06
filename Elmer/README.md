# Elmer FEM - módulo de instalación y validación

Este módulo tiene como objetivo centralizar la instalación y la validación de Elmer FEM dentro del repositorio. El enfoque está en dejar una estructura reproducible, con nombres estándar, documentación clara y un script de instalación más robusto.

## Objetivo del repositorio

Elmer es un solver de elementos finitos multiphísico de código abierto. En este repositorio se usa principalmente como herramienta de referencia para:

- instalar Elmer FEM desde código fuente,
- preparar un flujo de trabajo reproducible,
- ejecutar pruebas mínimas de validación,
- documentar un caso base sencillo.

## Estructura recomendada

```text
Elmer/
├── README.md
├── scripts/
│   └── install_elmer.sh
├── docs/
│   ├── INSTALLATION.md
│   └── TROUBLESHOOTING.md
├── examples/
│   └── heat_plate/
│       ├── README.md
│       └── case.sif
├── tests/
│   └── validate_install.sh
├── elmer_script.sh
├── Readme.md
└── test/
```

## Qué hemos mejorado

### 1. Estandarización de nombres y carpetas

- Se normaliza la nomenclatura del proyecto usando mayúsculas en `README.md` y carpetas descriptivas como `scripts/`, `docs/`, `tests/`.
- Se mantienen archivos antiguos por compatibilidad, pero se deja claro el flujo actual preferido.
- Se separa la instalación de la documentación y de la validación.

### 2. Script más robusto

El instalador ya no se considera un script improvisado. La versión actual:

- usa `set -Eeuo pipefail`,
- valida dependencias antes de compilar,
- separa el trabajo en pasos claros,
- detecta si el usuario tiene permisos de `sudo`,
- evita sobrescribir el entorno del usuario sin comprobarlo,
- usa `cmake -S ... -B ...` y `cmake --build --install`,
- genera un bloque de entorno solo si aún no existe,
- valida la instalación final con comandos básicos.

## Uso recomendado

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
bash scripts/install_elmer.sh
```

Luego, para validar:

```bash
bash tests/validate_install.sh
```

## Documentación

- [docs/INSTALLATION.md](docs/INSTALLATION.md)
- [docs/TUTORIAL_HEAT_PLATE.md](docs/TUTORIAL_HEAT_PLATE.md)
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

## Referencias útiles

- Elmer FEM: https://www.elmerfem.org/
- Elmer tutorials: https://www.nic.funet.fi/index/elmer/doc/

## Estado

El repositorio ya no se ve como un script suelto, sino como una base más estructurada para instalación, validación y uso de un caso mínimo de referencia.
