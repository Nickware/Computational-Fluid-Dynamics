# Code_Saturne

Code_Saturne es un solver de CFD de código abierto desarrollado por EDF. Se usa para simular flujos internos y externos con distintos niveles de complejidad física: incompresible, compresible, con transferencia de calor, turbulencia y fenómenos multi-físicos.

Este módulo del repositorio está orientado a preparar y automatizar la instalación del software en sistemas GNU/Linux, especialmente basados en Ubuntu/Debian.

## Objetivo de este directorio

- Centralizar la instalación de Code_Saturne.
- Documentar la preparación del entorno y dependencias.
- Facilitar la reproducción del proceso en distintos equipos.
- Servir como base para casos prácticos de simulación CFD.

## Archivos principales

- `install_code_saturne.sh`: instalador principal del software.
- `examples/`: directorio con casos de ejemplo y guías de uso.
- `README.md`: esta documentación.

## Requisitos

- GNU/Linux con soporte de `sudo`
- Python 3
- `bash`, `wget`, `tar`
- Acceso a internet o una distribución local del tarball

## Uso rápido

```bash
cd Code_Saturne
chmod +x install_code_saturne.sh
./install_code_saturne.sh
```

Al final, el script intenta:

1. Descargarse o usar un tarball local.
2. Instalar dependencias del sistema.
3. Generar la configuración del build.
4. Compilar Code_Saturne.
5. Añadir el binario al PATH y crear un alias `code_saturne`.

## Estructura recomendada

```text
Code_Saturne/
├── README.md
├── install_code_saturne.sh
├── examples/
│   └── cavity_case/
│       └── README.md
└── ...
```

## Referencias oficiales

- Sitio oficial: https://www.code-saturne.org
- Documentación: sección de instalación y casos de uso del proyecto
- Complementos comunes: Salome Meca, ParaView

## Nota importante

Este repositorio no pretende reemplazar la documentación oficial del proyecto. Su objetivo es ofrecer una base reproducible para la instalación y una guía mínima para empezar a trabajar con CFD.
