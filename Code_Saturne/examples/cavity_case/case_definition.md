# Definición del caso de cavidad 2D

## Propósito

Estudiar el comportamiento del flujo en una cavidad cuadrada con una pared móvil superior, como caso clásico de validación y análisis de recirculación.

## Geometría

- Dominio: cuadrado unitario
- Coordenadas: $x \in [0,1]$, $y \in [0,1]$
- Escala física: adimensional

## Condiciones de contorno

- Pared superior: $u = U_0$, $v = 0$
- Paredes inferior, izquierda y derecha: $u = v = 0$
- Presión: referencia en un punto o condición compatible con el solver

## Propiedades del fluido

- Fluido: incompresible
- Viscosidad: función del número de Reynolds
- Densidad: constante

## Parámetros de estudio

- Reynolds: 100, 400, 1000, 2500, etc.
- Velocidad de la pared superior: $U_0 = 1$
- Tiempo final: según el tipo de simulación
- Tolerancia de convergencia: definida por el caso y la versión del solver

## Variables de salida

- campo de velocidad
- campo de presión
- líneas de corriente
- mapas de vorticidad
- perfiles de velocidad en secciones transversales

## Criterios de validación

- simetría cualitativa del flujo,
- presencia de recirculación primaria y secundaria,
- estabilidad de la solución,
- comparación con referencias bibliográficas.

## Observaciones

Este caso sirve como base para validar el correcto funcionamiento del solver, la malla y la configuración de condiciones de contorno antes de pasar a geometrías más complejas.
