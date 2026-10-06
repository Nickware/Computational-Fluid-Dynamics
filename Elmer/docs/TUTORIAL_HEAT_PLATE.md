# Tutorial mínimo: conducción estacionaria en una placa cuadrada

Este tutorial sirve como primera prueba funcional de Elmer FEM en un caso simple y reproducible.

## 1. Objetivo

Resolver la ecuación de conducción en estado estacionario en una placa cuadrada con una temperatura fija en el lado izquierdo y otra temperatura fija en el derecho.

## 2. Suposiciones del problema

- dominio 2D: cuadrado de lado 1
- material homogéneo
- no hay fuente interna de calor
- condiciones de contorno:
  - lado izquierdo: $T = 100\,^{\circ}C$
  - lado derecho: $T = 0\,^{\circ}C$
  - lados superior e inferior: aislados

## 3. Preparación de la malla

Puedes crear una malla rectangular sencilla con Gmsh o con cualquier generador que exporte un archivo compatible con Elmer.

Ejemplo conceptual:

```bash
# crear un archivo de malla llamado placa.msh
```

Luego conviértelo si es necesario:

```bash
ElmerGrid 14 2 placa.msh -out placa
```

## 4. Caso de ejemplo

Crea un archivo `plate.sif` con la configuración del problema:

```text
Header
  CHECK KEYWORDS Warn
End

Simulation
  Max Output Level = 5
  Coordinate System = Cartesian
  Coordinate Mapping(3) = 1 2 3
  Simulation Type = Steady State
  Steady State Max Iterations = 1
  Output Intervals = 1
End

Body 1
  Name = "solid"
  Equation = 1
  Material = 1
End

Equation 1
  Name = "Heat"
  Active Solvers = 1
End

Solver 1
  Equation = Heat Equation
  Procedure = "HeatSolve" "HeatSolver"
  Variable = Temperature
  Linear System Solver = Direct
  Linear System Direct Method = UMFPACK
End

Material 1
  Name = "steel"
  Heat Conductivity = 1.0
  Density = 1.0
  Heat Capacity = 1.0
End

Boundary Condition 1
  Target Boundaries(1) = 1
  Temperature = 100.0
End

Boundary Condition 2
  Target Boundaries(1) = 2
  Temperature = 0.0
End

Boundary Condition 3
  Target Boundaries(2) = 3 4
  Heat Flux = 0.0
End
```

## 5. Ejecución

```bash
ElmerSolver plate.sif
```

## 6. Validación visual

Se espera una solución con:

- temperatura alta en el lado izquierdo,
- temperatura baja en el lado derecho,
- un gradiente casi lineal en el interior,
- flujo térmico nulo en los bordes superior e inferior.

## 7. Recomendación práctica

Si estás comenzando, lo mejor es comprobar primero que el entorno funciona con la validación mínima:

```bash
bash tests/validate_install.sh
```

Y luego ejecutar este tutorial en una malla sencilla antes de pasar a casos más complejos.
