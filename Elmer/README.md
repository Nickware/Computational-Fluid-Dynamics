# Elmer FEM - estructura activa y compatibilidad

Este repositorio tiene una estructura activa clara y una capa de compatibilidad para no romper workflows antiguos.

## 1. Directorios activos

Los siguientes son la versión canónica del proyecto:

```text
Elmer/
├── README.md                     # índice principal y referencia de trabajo
├── install/
│   └── install_elmer.sh         # instalador principal
├── examples/
│   └── heat_plate/
│       ├── README.md             # ejemplo didáctico / conceptual
│       └── geometry/
│           └── plate.geo
├── cases/
│   └── heat_plate/
│       ├── README.md             # caso ejecutable y validable
│       ├── case.sif
│       └── run_case.sh
├── docs/
│   ├── INSTALLATION.md          # guía de instalación
│   ├── TUTORIAL_HEAT_PLATE.md   # tutorial mínimo
│   └── TROUBLESHOOTING.md       # solución de problemas
├── tests/
│   ├── validate_install.sh       # validación del entorno
│   └── validate_case.sh          # validación del caso de ejemplo
└── .
```

## 2. Diferencia entre examples y cases

- examples/heat_plate: ejemplo educativo y conceptual. Sirve para entender la geometría, las ecuaciones y el problema físico.
- cases/heat_plate: caso listo para ser ejecutado y validado con Elmer, con un flujo más cercano a una simulación real.

Son complementarios, no duplicados funcionales.

## 3. Compatibilidad y legado

Las siguientes rutas quedan como compatibilidad histórica, pero no son la referencia principal:

- Readme.md: copia legacy del README principal
- test/: contenido antiguo de pruebas
- scripts/: legado de instalación; ahora solo delega a install/
- elmer_script.sh: wrapper de compatibilidad

## 4. Uso recomendado

### Instalación

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
bash install/install_elmer.sh
```

### Validación mínima

```bash
bash tests/validate_install.sh
```

### Caso base

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer/cases/heat_plate
bash run_case.sh
```

## 5. Documentación

- [docs/INSTALLATION.md](docs/INSTALLATION.md)
- [docs/INSTALLATION_CHECKLIST.md](docs/INSTALLATION_CHECKLIST.md)
- [docs/REPRODUCIBLE_WORKFLOW.md](docs/REPRODUCIBLE_WORKFLOW.md)
- [docs/POSTPROCESSING_HEAT.md](docs/POSTPROCESSING_HEAT.md)
- [docs/TUTORIAL_HEAT_PLATE.md](docs/TUTORIAL_HEAT_PLATE.md)
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

## 6. Flujo reproducible recomendado

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
bash install/install_elmer.sh
source ~/.bashrc
bash tests/validate_install.sh
bash tests/validate_case.sh
cd cases/heat_plate
bash run_case.sh
python3 postprocess_heat.py --demo
```

## 7. Estado del repositorio

La estructura está ahora orientada a un uso más claro: instalación, ejemplos didácticos, casos ejecutables y validación. La duplicación legacy se mantiene solo para compatibilidad, no como ruta activa.
