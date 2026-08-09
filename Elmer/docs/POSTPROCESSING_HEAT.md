# Postprocesado del caso de calor

Este flujo compara la solución analítica esperada con la salida numérica del caso de Elmer.

## 1. Solución esperada

Para una placa cuadrada con temperatura fija en el borde izquierdo y derecho, la solución analítica es aproximadamente:

$$
T(x) = 100 \left(1 - \frac{x}{L}\right)
$$

con $L=1$, por lo que:

- $T(0) = 100$
- $T(1) = 0$
- el perfil es lineal en el dominio.

## 2. Ejecución del postprocesado

### Modo demostración

Si aún no existe una salida real del solver, se puede usar un perfil sintético para verificar el flujo del análisis:

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
python3 cases/heat_plate/postprocess_heat.py --demo
```

### Con un resultado real

Si ya tienes un archivo `.vtu` o `.csv` con temperatura en función de la posición:

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
python3 cases/heat_plate/postprocess_heat.py --result-file cases/heat_plate/results/temperature_profile.csv
```

También puede detectar automáticamente archivos dentro de la carpeta del caso:

```bash
python3 cases/heat_plate/postprocess_heat.py
```

## 3. Formato esperado de resultados

### CSV simple

El script acepta un CSV con columnas como:

```csv
x,temperature
0,100
0.25,75
0.5,50
0.75,25
1,0
```

### VTU/VTK

Si se usa un archivo VTU, el script intenta leer un campo llamado:

- Temperature
- temperature
- T
- temp

## 4. Interpretación del resultado

La comparación genera un archivo CSV con:

- x
- expected
- actual
- error

Además calcula el RMSE:

$$
RMSE = \sqrt{\frac{1}{N}\sum_{i=1}^{N}(T_i^{\text{actual}}-T_i^{\text{esperado}})^2}
$$

Un RMSE cercano a cero indica que la simulación sigue la solución esperada del problema de conducción.

## 5. Ruta de salida

El reporte se guarda en:

```text
cases/heat_plate/results/temperature_comparison.csv
```
