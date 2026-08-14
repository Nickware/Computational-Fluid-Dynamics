# Example: heat_plate

Este ejemplo presenta un caso mínimo de conducción térmica en estado estacionario usando Elmer FEM.

## Propósito

Resolver una placa cuadrada con una diferencia de temperatura aplicada entre dos bordes, evaluando el campo térmico y la respuesta del sistema.

## Geometría

- dominio: cuadrado unitario
- coordenadas: $[0,1] \times [0,1]$

## Condiciones de contorno

- borde izquierdo: $T = 100\,^{\circ}C$
- borde derecho: $T = 0\,^{\circ}C$
- bordes superior e inferior: aislados

## Archivos

- `geometry/plate.geo`: definición geométrica de la malla
- `mesh/`: directorio de salida de la malla, generado con Gmsh

## Ejecución

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer/examples/heat_plate
# si se dispone de Gmsh
# gmsh -2 geometry/plate.geo -o mesh/plate.msh
```

## Resultado esperado

Se espera un campo casi lineal con mayor temperatura hacia el lado izquierdo y menor hacia el lado derecho.
