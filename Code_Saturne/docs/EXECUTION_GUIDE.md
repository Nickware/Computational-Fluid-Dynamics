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

Consideraciones sugeridas:

- Dominio: cuadrado unitario, $L = 1$
- Fluido: agua o aire, según el estudio
- Viscosidad: variable según número de Reynolds
- Velocidad de la pared superior: $U_0 = 1$
- Condición de contorno:
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

El script base es una plantilla; para un caso real se debe ajustar a la versión exacta de Code_Saturne y a la estructura de archivos del estudio.

## 9. Supervisión de resultados

Durante la ejecución, revisar:

- convergencia del residual,
- evolución de la energía cinética,
- campo de velocidad,
- campo de presión,
- líneas de corriente.

Se recomienda guardar resultados en:

```text
examples/cavity_case/results/
```

## 10. Postprocesado

Se debe exportar la solución a un formato visualizable, por ejemplo usando herramientas como ParaView o una visualización local del campo de velocidad.

## 11. Buenas prácticas de proyecto de investigación

- Documentar cada caso con un pequeño resumen ejecutivo.
- Guardar la configuración exacta de malla y parámetros.
- Registrar la versión del solver y del sistema operativo.
- Separar geometría, malla, ejecución y resultados.
- Mantener un registro de hipótesis, observaciones y resultados.

## 12. Siguiente nivel

Una vez validado el caso base, es posible ampliar el estudio con:

- distintos números de Reynolds,
- refinamiento de malla,
- comparación con solución analítica o bibliográfica,
- simulación transitoria con pasos temporales variables,
- análisis de desprendimiento o estabilidad numérica.
