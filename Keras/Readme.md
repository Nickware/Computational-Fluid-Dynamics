
## pressNavStok2D.py

Script diseñado para cargar un modelo entrenado de TensorFlow/Keras que predice el campo de velocidad y presión de un flujo de fluido en un dominio bidimensional, y luego visualizar la presión predicha en dicho dominio.

### Descripción del script

- Importa las librerías necesarias: NumPy para manejo numérico, Matplotlib para visualización y TensorFlow/Keras para cargar el modelo de red neuronal.
- Carga un modelo guardado previamente llamado `fluid_model.keras` sin compilarlo (probablemente porque sólo se usará para inferencia/predicción).
- Define un dominio espacial 2D con líneas equidistantes en $x$ e $y$ entre $-1$ y $1$, y construye una malla usando `np.meshgrid`.
- Crea un arreglo para el tiempo `t_grid` con ceros, asumiendo un flujo estacionario (sin dependencia temporal).
- Prepara la entrada para el modelo juntando los vectores $x$, $y$ y $t$ en una matriz con la forma adecuada para el modelo.
- Usa el modelo para predecir las salidas sobre la malla. Se asume que la salida tiene al menos tres componentes: 
  - $$u$$ (componente x de velocidad),
  - $$v$$ (componente y de velocidad),
  - $$p$$ (presión).
- Reshapea las predicciones para que coincidan con la forma de la malla.
- Visualiza el campo de presión $$p$$ usando un mapa de colores con `contourf` de Matplotlib, con barra de colores, título y ejes rotulados.

### Contexto típico de uso

`pressNavStok2D.pyt` sería útil en la evaluación o visualización de resultados de un modelo de aprendizaje automático entrenado para problemas de dinámica de fluidos, como predicción de campos de velocidad y presión. Por ejemplo, un modelo que aprende a resolver las ecuaciones de Navier-Stokes para un flujo estacionario.

La visualización final permite observar la distribución espacial de la presión en el dominio 2D predefinido, facilitando análisis cualitativo o cuantitativo.

### Perspectivas

`pressNavStok2D.pyt` se podría ampliar para visualizar también los campos de velocidad usando quiver o streamplot con los componentes $$u$$ y $$v$$.

## velocityNavStok2D.py

Script diseñado para visualizar el campo de velocidades de un fluido predicho por un modelo de aprendizaje automático previamente entrenado. Utiliza una red neuronal (TensorFlow/Keras) que estima los componentes de la velocidad ($$u, v$$) y la presión ($$p$$) en un dominio bidimensional.

### Estructura y propósito del script

- Importa las librerías necesarias: NumPy para manipulación de datos, Matplotlib para graficar y TensorFlow/Keras para cargar el modelo.
- Carga un modelo guardado (`fluid_model.keras`) que ha sido entrenado para predecir el comportamiento de un flujo (campos de velocidad y presión) en cierto dominio espacial.
- Define un dominio bidimensional para $$x$$ y $$y$$, desde $-1$ hasta $1$, usando una malla de $100x100$ puntos.
- Crea una matriz para el tiempo (`t_grid`), llena de ceros, lo que representa un flujo estacionario (sin dependencia temporal).
- Junta las coordenadas y el tiempo en una matriz de entrada que es compatible con la red.
- Obtiene las predicciones del modelo: la salida tiene al menos tres componentes $(u, v, p)$.
- Extrae los componentes de velocidad ($$u, v$$) y los reordena en la forma de la malla.
- Opcionalmente extrae la presión ($$p$$), aunque no la grafica.
- Visualiza el campo de velocidades con `plt.quiver`, que dibuja flechas en cada punto del dominio para mostrar la dirección y magnitud del flujo.

### Utilidad de la visualización con quiver

El uso de `quiver` permite ver fácilmente patrones de flujo, como zonas de recirculación, vórtices, flujos laminares o turbulentos, dependiendo del problema y cómo fue entrenado el modelo.

Esta herramienta es especialmente útil en simulaciones de dinámica de fluidos computacional (CFD) donde los campos de velocidad resultantes pueden mostrar información crucial sobre la naturaleza y el comportamiento del sistema bajo estudio.

### Perspectivas

`velocityNavStok2D.py` podría extenderse para graficar también la presión, usar streamlines con `plt.streamplot` o animaciones para flujos no estacionarios.
