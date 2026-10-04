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

## Nota

Este archivo no sustituye la sintaxis exacta de Code_Saturne. Sirve como punto de partida para estructurar un caso real siguiendo la documentación oficial del solver.
