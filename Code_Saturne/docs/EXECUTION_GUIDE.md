# Guía de ejecución paso a paso para un caso de cavidad en Code_Saturne

Esta guía describe un flujo de trabajo reproducible para un caso de cavidad 2D, con enfoque de proyecto de investigación.

## 1. Objetivo del caso

El caso de cavidad es una configuración clásica de CFD para verificar el comportamiento de un fluido dentro de un dominio cerrado. En esta versión, se considera:

- geometría bidimensional,
- cavidad cuadrada,
- tapa superior desplazándose a velocidad constante,
- condiciones de no deslizamiento en las paredes,
- flujo viscoso, incompresible y transitorio o estacionario.

El objetivo es observar la estructura recirculante principal y la formación de vortices.

## 2. Parámetros geométricos y físicos

Caso base recomendado para estudio reproducible:

- Dominio: cuadrado unitario, $L = 1$
- Fluido: incompresible, Newtoniano
- Velocidad de la pared superior: $U_0 = 1$
- Número de Reynolds: $Re = 100, 400, 1000, 3200$
- Viscosidad: $\nu = U_0 L / Re$
- Paso temporal: $\Delta t = 10^{-3}$ a $5 \times 10^{-3}$
- Tiempo total: $t_{final} = 20$ a $50$

Condición de contorno:

- pared superior: velocidad tangencial $u = U_0$
- paredes restantes: $u = 0$
- presión: condición de referencia o neutra según el caso

## 3. Estructura del caso

```text
examples/cavity_case/
├── README.md
├── case_definition.md
├── geometry/
│   └── cavity.geo
├── mesh/
│   ├── generate_mesh.sh
│   └── cavity.msh
├── run_case.sh
├── results/
│   └── README.md
└── scripts/
    └── postprocess.sh
```

## 4. Preparación del entorno

Antes de ejecutar:

```bash
cd Computational-Fluid-Dynamics/Code_Saturne
chmod +x install_code_saturne.sh code_saturne_script.sh
./install_code_saturne.sh
source ~/.bashrc
```

Verifica que el ejecutable esté disponible:

```bash
code_saturne --help
```

## 5. Definición del caso

El archivo [examples/cavity_case/case_definition.md](../examples/cavity_case/case_definition.md) debe documentar:

- propósito del estudio,
- número de Reynolds,
- propiedades del fluido,
- malla usada,
- pasos temporales,
- criterios de convergencia,
- y variables de salida.

## 6. Generación de la geometría y la malla

La geometría base se incluye en:

- [examples/cavity_case/geometry/cavity.geo](../examples/cavity_case/geometry/cavity.geo)

Para generar la malla:

```bash
cd examples/cavity_case/mesh
./generate_mesh.sh
```

Este script está pensado como base para malla estructurada o no estructurada, dependiendo de la herramienta disponible en el entorno.

## 7. Preparación de archivos de entrada

Se recomienda crear una carpeta de caso con:

- geometría y malla,
- condiciones de contorno,
- propiedades del fluido,
- variables de transporte,
- esquema numérico.

La organización final debe facilitar la reproducción del estudio y la comparación de resultados entre ejecuciones.

## 8. Ejecución del caso

La ejecución base se hace desde el directorio del caso:

```bash
cd examples/cavity_case
./run_case.sh
```

La versión más realista del caso debe definir variables como:

```bash
export REYNOLDS=1000
export DT=0.001
export T_FINAL=20
export MESH_FILE="mesh/cavity.msh"
export RESULTS_DIR="results"
```

Esto permite ejecutar varias secuencias de simulación con distintos parámetros, manteniendo la reproducibilidad del estudio.

## 9. Supervisión de resultados

Durante la ejecución, revisar:

- convergencia del residual,
- evolución de la energía cinética,
- campo de velocidad y vorticidad,
- líneas de corriente,
- comportamiento temporal del flujo en puntos de control.

Se recomienda guardar resultados en:

```text
examples/cavity_case/results/
```

## 10. Postprocesado técnico

Se debe exportar la solución a un formato visualizable y cuantificar al menos:

- perfiles de velocidad en $x = 0.5$ y $y = 0.5$,
- vorticidad en region central,
- energía cinética media,
- evolución temporal de velocidad en puntos de referencia,
- diferencia entre solución transitoria y casi estacionaria.

## 11. Buenas prácticas de proyecto de investigación

- Documentar cada caso con un pequeño resumen ejecutivo.
- Guardar la configuración exacta de malla, viscosidad y tiempo final.
- Registrar versión del solver, sistema operativo y dependencias.
- Separar geometría, malla, ejecución, postprocesado y resultados.
- Mantener un registro de hipótesis, observaciones y resultados para comparar casos.

## 12. Siguiente nivel

Una vez validado el caso base, es posible ampliar el estudio con:

- distintas series de Reynolds,
- refinamiento de malla,
- comparación con solución analítica o bibliográfica,
- simulación transitoria con pasos temporales variables,
- análisis de estabilidad y sensibilidad numérica,
- estudio de vorticidad y estructura de torbellinos.
