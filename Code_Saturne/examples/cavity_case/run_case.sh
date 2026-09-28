#!/usr/bin/env bash
set -euo pipefail

REYNOLDS="${REYNOLDS:-1000}"
DT="${DT:-0.001}"
T_FINAL="${T_FINAL:-20}"
MESH_FILE="${MESH_FILE:-mesh/cavity.msh}"
RESULTS_DIR="${RESULTS_DIR:-results}"

echo "========================================"
echo "  Caso de cavidad 2D: entorno realista"
echo "========================================"
echo ""
echo "Parámetros del caso:"
echo "  Reynolds: $REYNOLDS"
echo "  dt:       $DT"
echo "  t_final:  $T_FINAL"
echo "  mesh:     $MESH_FILE"
echo "  output:   $RESULTS_DIR"
echo ""

if [[ ! -f "$MESH_FILE" ]]; then
    echo "La malla no existe: $MESH_FILE"
    echo "Genera la malla antes de ejecutar el caso."
    echo "Ejemplo:"
    echo "  cd mesh && ./generate_mesh.sh"
    exit 1
fi

mkdir -p "$RESULTS_DIR"

echo "Iniciando simulación transitoria para la cavidad..."

echo ""
echo "Plantilla técnica para la ejecución real:"
echo "  code_saturne --case \"$PWD\" --run"
echo "  # o el equivalente según la versión del solver"
echo ""
echo "Se recomienda registrar:"
echo "  - residuos del sistema"
echo "  - evolución de velocidad en puntos de control"
echo "  - perfiles de velocidad en x=0.5 y y=0.5"
echo "  - mapas de vorticidad y flujo recirculante"
echo ""
echo "Los resultados deben guardarse en $RESULTS_DIR/"
