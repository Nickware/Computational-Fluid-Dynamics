# Case: heat_plate

Caso representativo de conducción térmica en estado estacionario con Elmer FEM.

## Ecuación gobernante

La ecuación de calor en régimen estacionario se escribe como:

$$
\nabla \cdot (k \nabla T) = 0
$$

para un material homogéneo con conductividad $k = 1$.

## Condiciones de frontera

- izquierdo: $T = 100$
- derecho: $T = 0$
- superior e inferior: flujo térmico nulo

## Variables a comprobar

- temperatura en el dominio,
- gradiente de temperatura,
- equilibrio energético local,
- ausencia de fuentes internas.

## Ejecución sugerida

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer/cases/heat_plate
# 1. Generar malla si hace falta
# gmsh -2 ../../examples/heat_plate/geometry/plate.geo -o plate.msh
# 2. Ejecutar ElmerSolver
# ElmerSolver case.sif
```

## Resultado esperado

El campo de temperatura debe mostrar una variación casi lineal desde el lado caliente hacia el frío, con simetría espacial en ausencia de fuentes internas.
