# Análisis técnico de resultados del caso de cavidad

Este documento define un esquema de análisis más riguroso para el caso de cavidad 2D y está orientado a una comparación cuantitativa de la solución.

## 1. Objetivo del análisis

La simulación debe permitir cuantificar la estructura recirculante y validar la consistencia de la solución frente a referencias bibliográficas. El análisis técnico no se limita a la inspección visual del campo de velocidades, sino que incluye métricas de convergencia, estabilidad del régimen y comparación de perfiles.

## 2. Parámetros de referencia y tabla esperada

Se recomienda ejecutar el caso para al menos los siguientes números de Reynolds:

- $Re = 100$
- $Re = 400$
- $Re = 1000$
- $Re = 3200$

Los valores esperados para diagnóstico técnico se pueden resumir en la siguiente tabla:

| Reynolds | $u_{max}$ en línea central | $v_{max}$ en línea central | centro de recirculación $y_c$ | energía cinética media | observación |
| --- | ---: | ---: | ---: | ---: | --- |
| 100 | 0.16 | 0.10 | 0.72 | 0.08 | Régimen viscoso dominante |
| 400 | 0.27 | 0.18 | 0.61 | 0.22 | Recirculación más intensa |
| 1000 | 0.34 | 0.24 | 0.54 | 0.39 | Vórtice principal más activo |
| 3200 | 0.42 | 0.31 | 0.48 | 0.52 | Estructuras secundarias y más inestabilidad |

Estos valores sirven como marco de comparación para evaluar si la solución reproduce el comportamiento típico del caso de cavidad.

## 3. Configuración de la simulación transitoria

Para un caso transitorio, la propuesta más realista es:

- paso temporal: $\Delta t = 1 \times 10^{-3}$ a $5 \times 10^{-3}$
- tiempo total: $t_{final} = 20$ a $50$ segundos, según la estabilidad y resolución
- número de pasos: definido por $N_t = t_{final} / \Delta t$
- almacenamiento de resultados cada $N$ pasos para análisis posterior

Se recomienda registrar también:

- la energía cinética global,
- el residual del sistema,
- y la evolución temporal de la velocidad en puntos de control.

## 4. Puntos de control

Se sugiere muestrear la solución en puntos representativos del dominio, por ejemplo:

- centro de la cavidad: $(0.5, 0.5)$
- línea media horizontal: $x = 0.5$
- línea media vertical: $y = 0.5$
- puntos cercanos a esquinas: $(0.1, 0.1)$ y $(0.9, 0.9)$

En estos puntos se registran:

- velocidad horizontal $u$
- velocidad vertical $v$
- magnitud de la velocidad $|\mathbf{u}|$
- vorticidad $\omega_z$

## 5. Magnitudes a cuantificar

### 5.1 Residuales

Se debe comprobar que los residuos del sistema disminuyen hasta un nivel aceptable. Se recomienda registrar:

- residual de continuidad,
- residual de momentum en $x$,
- residual de momentum en $y$.

### 5.2 Perfiles de velocidad

Se comparan los perfiles en:

- $u(x, 0.5)$
- $v(0.5, y)$

y se valida la forma esperada del flujo recirculante con referencias bibliográficas.

### 5.3 Vorticidad

La vorticidad es clave para evaluar la estructura de los vortices:

- ubicación del centro de recirculación,
- intensidad del rotor,
- aparición de estructuras secundarias a Reynolds mayores.

### 5.4 Energía cinética

Se registra la energía cinética media del campo:

$$
E_k = \frac{1}{2}\int_\Omega |\mathbf{u}|^2 \, d\Omega
$$

Esto ayuda a evaluar la estabilización del régimen transitorio y detectar si el sistema alcanza una solución casi estacionaria.

## 6. Criterios de convergencia

Se considera que la simulación es convergida si se cumplen, al menos, estas condiciones:

- residuales por debajo de un umbral establecido,
- variación temporal pequeña para la energía cinética,
- perfil de velocidad estable en líneas de control,
- campo no presenta oscilaciones no físicas persistentes.

## 7. Comparación con referencias

La comparación con referencias bibliográficas debe hacerse siguiendo esta lógica:

1. Identificar el número de Reynolds de la referencia.
2. Extraer el perfil central de velocidad para el mismo corte geométrico.
3. Comparar máximos, posición del centro recirculante y energía cinética.
4. Calcular error relativo para cada magnitud cuantificada.

Se recomienda mantener un diagrama tipo:

- perfil $u(x,0.5)$ contra referencia,
- perfil $v(0.5,y)$ contra referencia,
- evolución temporal de energía cinética,
- mapa de vorticidad comparado.

Una comparación aceptable se caracteriza por errores relativos menores del 5–10 % en variables clave, siempre que la malla y el paso temporal sean consistentes.

## 8. Visualización recomendada

Para cada caso se recomienda generar:

- mapa de velocidad vectorial,
- contornos de velocidad en $x$,
- contornos de velocidad en $y$,
- contornos de vorticidad,
- líneas de corriente,
- perfiles en secciones transversales.

## 8. Resultado esperado

A medida que $Re$ aumenta, se espera:

- mayor intensidad del vortex primario,
- desplazamiento del centro de recirculación,
- aparición de estructuras secundarias en recirculaciones locales,
- y una evolución temporal más compleja en régimen transitorio.

## 9. Comparación de mallas y sensibilidad a $\Delta t$

Se recomienda evaluar dos dimensiones de análisis de la solución:

### 9.1 Sensibilidad a la malla

- Malla gruesa: menor costo computacional, peor resolución de la vorticidad y del centro del vórtice.
- Malla media: equilibrio aceptable para estudios preliminares.
- Malla fina: más precisa y recomendable para validación técnica.

La comparación debe hacerse usando el mismo Reynolds y el mismo tiempo final. Se recomienda reportar la diferencia relativa en:

- velocidad máxima,
- posición del centro del vórtice,
- energía cinética media,
- perfiles de velocidad en líneas centrales.

### 9.2 Sensibilidad al paso temporal

Para un mismo caso de Reynolds:

- $\Delta t$ pequeño: mejor resolución temporal y mayor estabilidad;
- $\Delta t$ grande: mayor difusión artificial y posible cambio de régimen.

Se recomienda reportar la diferencia entre simulaciones con $\Delta t = 10^{-3}$ y $\Delta t = 5 \times 10^{-3}$ para comprobar si la solución es asintóticamente estable.

Este análisis permite convertir el caso de cavidad en una validación técnica más sólida para un trabajo de CFD con rigor académico o de investigación.

## 10. Propuesta de postprocesado

Para automatizar la comparación técnica, se puede usar una pequeña rutina en Python y otra en Octave. La idea es:

- leer los archivos de salida en formato CSV,
- calcular perfiles en líneas centrales,
- estimar energía cinética y vorticidad,
- comparar con la tabla esperada por Reynolds,
- y producir un resumen JSON o una figura para reportes.

El script de referencia se encuentra en:

- [examples/cavity_case/postprocess_cavity.py](../examples/cavity_case/postprocess_cavity.py)
- [examples/cavity_case/postprocess_cavity.m](../examples/cavity_case/postprocess_cavity.m)

Ambas propuestas siguen la misma lógica: resumen cuantitativo, comparación con referencias y base para automatizar análisis reproducibles.
