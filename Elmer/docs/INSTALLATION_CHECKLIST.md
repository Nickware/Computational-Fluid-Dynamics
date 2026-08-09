# Checklist de validación de instalación de Elmer FEM

Esta checklist sirve para verificar que la instalación es correcta antes de ejecutar un caso de simulación.

## Validación de sistema

- [ ] El sistema operativo es compatible con Debian/Ubuntu.
- [ ] `git` está disponible.
- [ ] `cmake` está disponible.
- [ ] `make` está disponible.
- [ ] `gcc`, `g++` y `gfortran` están disponibles.
- [ ] Hay permisos suficientes para instalar paquetes o escribir en `/opt`.

## Validación de entorno

- [ ] `ELMER_HOME` apunta a la ruta de instalación esperada.
- [ ] La ruta `${ELMER_HOME}/bin` existe.
- [ ] `PATH` incluye `${ELMER_HOME}/bin`.
- [ ] `LD_LIBRARY_PATH` incluye `${ELMER_HOME}/lib`.
- [ ] El archivo `~/.bashrc` contiene las variables del entorno de Elmer.

## Validación funcional

- [ ] `ElmerSolver -h` responde sin error.
- [ ] `ElmerGrid -h` responde sin error.
- [ ] `ElmerGUI --help` responde si la GUI está instalada.
- [ ] El directorio de instalación contiene ejecutables esperados.

## Validación del caso mínimo

- [ ] El caso de prueba existe en `cases/heat_plate/case.sif`.
- [ ] La geometría existe en `examples/heat_plate/geometry/plate.geo`.
- [ ] El script de ejecución existe en `cases/heat_plate/run_case.sh`.
- [ ] La validación automática de caso ejecuta sin errores.

## Resultado esperado

La instalación se considera correcta cuando todos los elementos anteriores están verificados y la ejecución del caso mínimo se completa sin fallos de entorno ni de rutas.
