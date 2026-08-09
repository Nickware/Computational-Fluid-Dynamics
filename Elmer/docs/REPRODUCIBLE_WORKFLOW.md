# Flujo reproducible de Elmer FEM

Este flujo es la versión mínima y verificable para trabajar con Elmer de forma reproducible.

## 1. Preparación del entorno

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
bash install/install_elmer.sh
source ~/.bashrc
```

## 2. Validación de instalación

```bash
bash tests/validate_install.sh
```

Si la validación falla, revisar la checklist en [INSTALLATION_CHECKLIST.md](INSTALLATION_CHECKLIST.md).

## 3. Validación del caso base

```bash
bash tests/validate_case.sh
```

## 4. Ejecución del caso mínimo

```bash
cd cases/heat_plate
bash run_case.sh
```

## 5. Verificación de resultados

- Confirmar que el archivo de resultados se genera en la ruta esperada.
- Comprobar que la solución presenta el gradiente térmico esperado.
- Revisar errores del solver en el log de ejecución.
- Ejecutar el postprocesado para comparar la respuesta real con la solución analítica.

## 6. Postprocesado del caso de calor

```bash
cd /home/jntorresr/gitHub/Computational-Fluid-Dynamics/Elmer
python3 cases/heat_plate/postprocess_heat.py --demo
```

Si ya existe un resultado real:

```bash
python3 cases/heat_plate/postprocess_heat.py --result-file cases/heat_plate/results/temperature_profile.csv
```

El script genera un archivo CSV con `x`, `expected`, `actual` y `error`, y calcula el RMSE.

## 7. Buenas prácticas

- Mantener una estructura estable de carpetas.
- Usar una única ruta canónica para instalación.
- Registrar versiones del entorno y del caso.
- Mantener una validación mínima en cada nueva instalación.

## 7. Objetivo

El propósito del flujo es evitar que la instalación y la ejecución dependan de un entorno manual no documentado. Con esta estructura, el caso mínimo puede repetirse con un número muy reducido de pasos.
