# Resultados esperados y análisis técnico del caso de cavidad 2D

## 1. Objetivo del estudio

El caso de cavidad con pared móvil superior es un ejercicio clásico de validación en dinámica de fluidos computacional. El objetivo del estudio es evaluar la capacidad del solver para resolver flujo viscoso en un dominio cerrado, con sensibilidad a la malla y al paso temporal.

## 2. Parámetros del caso

- Geometría: cavidad cuadrada, dominio unitario
- Fluido: Newtoniano, incompresible
- Velocidad de la pared superior: $U_0 = 1$
- Número de Reynolds: $Re = 100, 400, 1000, 3200$
- Pasos temporales: $\Delta t = 10^{-3}, 5 \times 10^{-3}$
- Mallas: refinada y media

## 3. Comparación de mallas

Se recomienda comparar al menos dos niveles de resolución espacial para assessar la dependencia del resultado con la discretización:

| Nivel de malla | Número de celdas | Observación esperada |
| --- | ---: | --- |
| Malla gruesa | 25x25 | Solución más difusa, centro de vórtice menos preciso |
| Malla media | 50x50 | Balance aceptable entre coste y precisión |
| Malla fina | 100x100 | Mejora de la resolución de vorticidad y recirculación |

Se espera que la malla fina reduzca la desviación de los perfiles de velocidad respecto a la referencia y mejore la localización del centro de recirculación.

## 4. Sensibilidad al paso temporal

Se evalúa la sensibilidad del modelo a $\Delta t$ con un mismo nivel de malla:

| $\Delta t$ | Regimen esperado | Comentario |
| --- | --- | --- |
| $10^{-3}$ | Más estable y preciso | Coste computacional mayor |
| $5 \times 10^{-3}$ | Aceptable para casos transitorios | Puede mostrar mayor difusión artificial |

Se recomienda verificar que la energía cinética y los residuos no presenten oscilaciones artificiales persistentes.

## 5. Resultados esperados por Reynolds

| Reynolds | $u_{max}$ | $v_{max}$ | $y_c$ | $E_k$ | Comentario |
| --- | ---: | ---: | ---: | ---: | --- |
| 100 | 0.16 | 0.10 | 0.72 | 0.08 | Régimen dominado por viscosidad |
| 400 | 0.27 | 0.18 | 0.61 | 0.22 | Recirculación clara y estable |
| 1000 | 0.34 | 0.24 | 0.54 | 0.39 | Vórtice principal fuerte |
| 3200 | 0.42 | 0.31 | 0.48 | 0.52 | Mayor complejidad y formación secundaria |

## 6. Comparación con referencias

La comparación con referencias debe centrarse en:

- perfil de velocidad horizontal $u(x,0.5)$,
- perfil de velocidad vertical $v(0.5,y)$,
- posición del centro del vórtice,
- residual y energía cinética temporal,
- mapas de vorticidad y líneas de corriente.

Se recomienda reportar el error relativo respecto a la referencia para cada una de estas magnitudes, con un umbral de aceptación de 5–10 % para un caso bien resuelto.

## 7. Observaciones de validación

Se espera que, al aumentar $Re$:

- la zona central del flujo se vuelva más compleja,
- el centro del vórtice se desplace hacia el centro del dominio,
- y aparezcan estructuras secundarias de menor escala.

Asimismo, la solución debe mostrar una tendencia de convergencia al refinar la malla y reducir el paso temporal, siempre que la discretización sea suficientemente precisa.

## 8. Conclusión técnica

El caso de cavidad es una herramienta útil para validar la calidad numérica del solver, la resolución espacial y la robustez temporal. En un entorno académico, la combinación de mallas, pasos temporales y comparación con referencias convierte este ejemplo en una base sólida para trabajos de CFD reproducibles.
