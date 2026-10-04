# Code_Saturne

Code_Saturne es un solver de CFD de código abierto desarrollado por EDF. Se usa para simular flujos internos y externos con distintos niveles de complejidad física: incompresible, compresible, con transferencia de calor, turbulencia y fenómenos multi-físicos.

Este módulo del repositorio está orientado a preparar y automatizar la instalación del software en sistemas GNU/Linux, especialmente basados en Ubuntu/Debian.

## Objetivo de este directorio

- Centralizar la instalación de Code_Saturne.
- Documentar la preparación del entorno y dependencias.
- Facilitar la reproducción del proceso en distintos equipos.
- Servir como base para casos prácticos de simulación CFD.
- Proporcionar validación mínima del repositorio y guía de troubleshooting.

## Archivos principales

- `install_code_saturne.sh`: instalador principal del software.
- `code_saturne_script.sh`: wrapper compatible para invocar el instalador.
- `docs/USAGE.md`: guía de uso y flujo típico de trabajo.
- `docs/TROUBLESHOOTING.md`: solución a problemas frecuentes.
- `examples/cavity_case/`: caso base con guía y script de ejecución.
- `tests/validate_structure.sh`: validación mínima de estructura y sintaxis.
- `README.md`: esta documentación.

## Requisitos

- GNU/Linux con soporte de `sudo`
- Python 3
- `bash`, `wget`, `tar`
- Acceso a internet o una distribución local del tarball

## Uso rápido

```bash
cd Code_Saturne
chmod +x install_code_saturne.sh code_saturne_script.sh
./install_code_saturne.sh
```

Alternativa compatible:

```bash
./code_saturne_script.sh
```

## Validación del repositorio

Se puede ejecutar una validación mínima antes de instalar o continuar con un caso real:

```bash
cd Code_Saturne/tests
chmod +x validate_structure.sh
./validate_structure.sh
```

La validación comprueba:

- que existan los archivos esperados,
- que los scripts tengan sintaxis correcta,
- y que las herramientas base del entorno estén presentes.

## Estructura del proyecto

```text
Code_Saturne/
├── README.md
├── install_code_saturne.sh
├── code_saturne_script.sh
├── docs/
│   ├── USAGE.md
│   └── TROUBLESHOOTING.md
├── examples/
│   └── cavity_case/
│       ├── README.md
│       └── run_case.sh
├── tests/
│   └── validate_structure.sh
└── ...
```

## Troubleshooting

Si la instalación falla o no aparece el binario, consulta:

- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- [docs/USAGE.md](docs/USAGE.md)

## Referencias oficiales

- Sitio oficial: https://www.code-saturne.org
- Documentación: sección de instalación y casos de uso del proyecto
- Complementos comunes: Salome Meca, ParaView

## Nota importante

Este repositorio no pretende reemplazar la documentación oficial del proyecto. Su objetivo es ofrecer una base reproducible para la instalación, validación y puesta en marcha de un flujo mínimo de trabajo con CFD.
