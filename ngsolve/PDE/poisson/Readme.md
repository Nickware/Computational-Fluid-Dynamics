# 				Ecuación de Poisson en dos dimensiones

Este script de NGSolve resuelve la **ecuación de Poisson** en dos dimensiones, un problema elíptico fundamental en física e ingeniería. En este caso, la ecuación es:

−Δu=f

con la condición de contorno de Dirichlet u=0 en todo el borde del dominio. El script sigue los pasos típicos del método de elementos finitos para encontrar una solución numérica.

------

### Desglose del Script

1. ### **Configuración Inicial:**
   
   - `from ngsolve import *`: Importa todas las funcionalidades de NGSolve.
   - `ngsglobals.msg_level = 1`: Establece el nivel de mensajes para ver más información durante la ejecución.
   - `mesh = Mesh(unit_square.GenerateMesh(maxh=0.2))`: Crea una malla triangular para un cuadrado unitario. El parámetro `maxh=0.2` controla el tamaño máximo de los elementos de la malla, afectando la precisión de la solución.
2. ### **Espacio de Elementos Finitos:**
   
   - `fes = H1(mesh, order=3, dirichlet=[1,2,3,4])`: Define un **espacio de elementos finitos** `H1`, que consiste en funciones continuas que tienen derivadas de primer orden cuadradas integrables. La malla se divide en cuatro fronteras, y `dirichlet=[1,2,3,4]` le dice al solucionador que la condición de contorno u=0 se aplica a todas las fronteras.
3. ### **Formulación Variacional:**
   
   - `u = fes.TrialFunction()` y `v = fes.TestFunction()`: Declaran `u` como la función de prueba (la solución que buscamos) y `v` como la función de test (una función auxiliar para la formulación variacional).
   - `f = LinearForm(fes)`: Define el lado derecho de la ecuación.
   - `f += 32 * (y*(1-y)+x*(1-x)) * v * dx`: Aquí se especifica la función f (el término fuente).
   - `a = BilinearForm(fes, symmetric=True)`: Define la forma bilineal del lado izquierdo de la ecuación.
   - `a += grad(u)*grad(v)*dx`: Representa el término −Δu en su forma variacional.
4. ### **Ensamblaje y Solución:**
   
   - `a.Assemble()` y `f.Assemble()`: Ensamblan las matrices y vectores del sistema de ecuaciones lineales.
   - `gfu = GridFunction(fes)`: Crea una función de malla para almacenar la solución numérica.
   - `gfu.vec.data = a.mat.Inverse(...) * f.vec`: Este es el paso crucial. La línea resuelve el sistema lineal de ecuaciones, Ax=b, donde `A` es la matriz de `a`, `x` es el vector de coeficientes de la solución `gfu`, e `b` es el vector de `f`. `Inverse` es un solucionador directo de la matriz.
5. ### **Visualización y Verificación:**
   
   - `Draw (gfu)`: Dibuja la solución u en la GUI de Netgen.
   - `Draw (-grad(gfu), mesh, "Flux")`: Dibuja el gradiente negativo de la solución, que representa el flujo.
   - `exact = 16*x*(1-x)*y*(1-y)`: Se define la solución analítica exacta de la ecuación de Poisson para esta función f y condiciones de contorno.
   - `print ("L2-error:", sqrt (Integrate ( (gfu-exact)*(gfu-exact), mesh)))`: Calcula y muestra el error L2, que es una medida del error entre la solución numérica y la solución exacta. Este paso es fundamental para verificar la precisión del método de elementos finitos.
