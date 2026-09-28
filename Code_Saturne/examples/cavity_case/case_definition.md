# Definición del caso de cavidad 2D con enfoque realista

## Propósito

Estudiar la evolución temporal del flujo dentro de una cavidad cuadrada impulsada por la pared superior, con énfasis en la dependencia del número de Reynolds y en la cuantificación de la estructura recirculante.

## Geometría

- Dominio: cuadrado unitario
- Coordenadas: $x \in [0,1]$, $y \in [0,1]$
- Escala física: adimensional
- Malla base: uniforme y refinada en regiones de interés

## Condiciones de contorno

- Pared superior: $u = U_0$, $v = 0$; movimiento tangencial con velocidad $U_0 = 1$
- Paredes inferior, izquierda y derecha: $u = v = 0$
- Presión: referencia en un punto del dominio o condición compatible con el solver

## Propiedades del fluido

- Fluido: Newtoniano, incompresible
- Densidad: constante
- Viscosidad: $\nu = \dfrac{U_0 L}{Re}$

## Parámetros de estudio

Se recomienda resolver un conjunto de casos para evaluar sensibilidad a la viscosidad:

- $Re = 100$
- $Re = 400$
- $Re = 1000$
- $Re = 3200$

Configuración transitoria:

- $\Delta t = 1 \times 10^{-3}$ a $5 \times 10^{-3}$
- $t_{final} = 20$ a $50$
- almacenamiento cada $N$ pasos para análisis temporales

## Régimen dinámico

La simulación debe considerarse como transitoria, con la intención de observar:

- fase inicial de aceleración,
- estabilización del vórtice principal,
- evolución de la recirculación secundaria,
- posible aproximación a un estado casi estacionario.

## Variables de salida

- campo de velocidad $u,v$
- presión $p$
- líneas de corriente
- vorticidad $\omega_z$
- perfiles de velocidad en $x = 0.5$ y $y = 0.5$
- evolución temporal de energía cinética
- evolución temporal de residuos del sistema

## Criterios de validación

- comparación de perfiles con resultados de referencia,
- evolución estable de energía cinética,
- residuos por debajo del umbral establecido,
- consistencia de la estructura recirculante para cada Reynolds,
- reproducibilidad del resultado frente a cambios de malla o paso temporal.

## Observaciones de proyecto

Este caso es una base sólida para trabajos de CFD de nivel académico o de investigación porque permite validar:

- la resolución espacial,
- la sensibilidad a la viscosidad,
- la estabilidad temporal,
- la interpretación física del régimen recirculante,
- y la preparación para casos más complejos con geometrías no triviales.
