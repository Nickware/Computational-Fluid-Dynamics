#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo "  Caso base: cavidad 2D"
echo "========================================"
echo ""
echo "Este archivo es una plantilla para ejecutar un caso base de flujo en cavidad."
echo "Debe adaptarse al caso concreto de Code_Saturne que se quiera ejecutar."
echo ""
echo "Pasos recomendados:"
echo "  1. Preparar la geometría."
echo "  2. Generar la malla."
echo "  3. Definir condiciones de contorno."
echo "  4. Ejecutar code_saturne con el caso."
echo "  5. Revisar los resultados en results/."
echo ""

# Ejemplo de punto de entrada para casos reales:
# code_saturne --case "$PWD" --run
# o bien un comando equivalente según la versión de Code_Saturne.

echo "Plantilla lista. Ajusta los comandos reales según el caso concreto."
