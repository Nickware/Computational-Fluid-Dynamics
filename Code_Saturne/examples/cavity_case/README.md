# Caso base: cavidad 2D

Este ejemplo representa una estructura mínima para comenzar con una simulación de flujo en cavidad, un caso clásico en CFD.

## Objetivo

Estudiar el flujo incomprensible dentro de un dominio cuadrado con:
- pared inferior fija,
- pared superior moviéndose a velocidad constante,
- paredes laterales fijas,
- condición de no deslizamiento.

## Estructura sugerida

```text
cavity_case/
├── geometry/
│   └── cavity.geo
├── mesh/
│   └── cavity.msh
├── setup/
│   └── case_data.xml
├── results/
│   └── output/
├── run_case.sh
└── README.md
```

## Recomendación práctica

Antes de ejecutar una simulación real, se debe:

1. Generar la malla del dominio.
2. Definir las condiciones de contorno.
3. Configurar la viscosidad y el régimen de flujo.
4. Ejecutar Code_Saturne con el caso preparado.
5. Visualizar el campo de velocidad y presión.

## Idea de caso

- Dominio: cuadrado unitario, 2D.
- Fluido: Newtoniano, incompresible.
- Velocidad de la tapa: `U = 1 m/s`.
- Número de Reynolds: moderado para observar recirculación.

## Versión técnica del caso

Para convertir este caso en un ejemplo más riguroso, se recomienda:

1. ejecutar el estudio para varios Reynolds,
2. registrar evolución temporal en puntos de control,
3. comparar perfiles de velocidad con referencias,
4. documentar residuales y energía cinética,
5. usar una rutina de postprocesado para resumir los datos.

## Script de postprocesado recomendado

- Python: [postprocess_cavity.py](postprocess_cavity.py)
- Octave: [postprocess_cavity.m](postprocess_cavity.m)

## Tabla de referencia orientativa

| Reynolds | $u_{max}$ | $v_{max}$ | centro recirculación | energía cinética |
| --- | ---: | ---: | ---: | ---: |
| 100 | 0.16 | 0.10 | 0.72 | 0.08 |
| 400 | 0.27 | 0.18 | 0.61 | 0.22 |
| 1000 | 0.34 | 0.24 | 0.54 | 0.39 |
| 3200 | 0.42 | 0.31 | 0.48 | 0.52 |

## Nota

Este archivo no sustituye la sintaxis exacta de Code_Saturne. Sirve como punto de partida para estructurar un caso real siguiendo la documentación oficial del solver y un protocolo técnico de validación para CFD.
