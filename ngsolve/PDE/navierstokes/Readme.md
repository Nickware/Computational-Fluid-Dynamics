# Flujo de un fluido incompresible alrededor de un obstáculo cilíndrico

Este script de NGSolve simula el flujo de un fluido incompresible alrededor de un obstáculo cilíndrico, un problema clásico conocido como el flujo de Stokes o Navier-Stokes, dependiendo de los parámetros. Utiliza un método de elementos finitos para resolver las ecuaciones de movimiento.

Desglose del código y lo que hace cada parte:

### **1\. Configuración y Geometría**

El script comienza importando las librerías necesarias y definiendo las constantes del problema, como la **viscosidad (ν)**, el **paso de tiempo (τ)** y el **tiempo total de simulación (tend)**.

* **SplineGeometry**: Se usa para construir la geometría del dominio, que es un rectángulo (AddRectangle) con un círculo en su interior (AddCircle). Este círculo representa el obstáculo.  
* **bcs**: Las "boundary conditions" (condiciones de contorno) se definen para las fronteras del dominio: wall (pared), outlet (salida) e inlet (entrada). También se define una condición de contorno cyl para el cilindro.  
* **mesh.Curve(3)**: Este comando aumenta la precisión de la malla en las fronteras curvas, haciendo que se ajusten mejor a la forma del círculo.

### **2\. Espacios de Funciones y Formas Variacionales**

Aquí se definen los espacios donde vivirán las soluciones y se configuran las ecuaciones a resolver.

* **V \= VectorH1(...) y Q \= H1(...)**: Se crean dos espacios de elementos finitos. V es un espacio vectorial para la **velocidad** del fluido (u), y Q es un espacio escalar para la **presión** (p).  
* **X \= V\*Q**: Se combina la velocidad y la presión en un único espacio de producto.  
* **stokes \= nu\*...**: Esta es la formulación variacional discreta de las ecuaciones de Stokes. Incluye el término de viscosidad, la condición de incompresibilidad (div(u)\*q+div(v)\*p) y un término de estabilización para la presión.  
* **a \= BilinearForm(...)**: Crea la forma bilineal para el problema de Stokes, que representa el lado izquierdo de las ecuaciones lineales.

### **3\. Condiciones Iniciales y Solución Inicial**

Antes de comenzar la simulación en el tiempo, se necesita una solución inicial.

* **gfu \= GridFunction(X)**: Se crea una función de malla para almacenar la solución (velocidad y presión).  
* **uin \= CoefficientFunction(...)**: Se define un perfil de velocidad de entrada parabólico en la frontera inlet para simular un flujo que entra en el dominio.  
* **gfu.components\[0\].Set(uin, definedon=mesh.Boundaries("inlet"))**: Se aplica este perfil de velocidad como la condición de contorno de Dirichlet en la entrada.  
* **gfu.vec.data \+= inv\_stokes \* res**: Se resuelve el problema de Stokes de manera implícita para obtener la primera solución, que servirá como condición inicial.

### **4\. Bucle de Simulación Temporal**

El corazón del script es un bucle que avanza la simulación en el tiempo.

* **mstar \= BilinearForm(...)**: Se define una nueva forma bilineal para el método de integración temporal, en este caso, un esquema de "splitting" (división) entre Euler implícito y Euler explícito.  
* **conv \= BilinearForm(...)**: Representa el término no lineal de las ecuaciones de Navier-Stokes, que se encarga del transporte del momentum por el propio fluido. Se marca como nonassemble \= True porque se reevalúa en cada paso de tiempo.  
* **while t \< tend:**: El bucle principal de tiempo. En cada iteración:  
  1. Se aplica el término no lineal (conv.Apply).  
  2. Se calcula el residuo.  
  3. Se avanza la solución en el tiempo usando la forma implícita de Euler (gfu.vec.data \-= ...).  
  4. El tiempo (t) se incrementa y la visualización se actualiza (Redraw()).

Este script demuestra una forma muy potente de resolver problemas de flujo de fluidos de manera iterativa utilizando elementos finitos y un esquema de avance temporal, todo ello gestionado con la sintaxis concisa y expresiva de NGSolve.