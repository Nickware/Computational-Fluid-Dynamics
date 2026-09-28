#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEOM_DIR="$(cd "$SCRIPT_DIR/../geometry" && pwd)"

if command -v gmsh >/dev/null 2>&1; then
    echo "Generando malla con Gmsh..."
    gmsh -2 "$GEOM_DIR/cavity.geo" -o "$SCRIPT_DIR/cavity.msh"
else
    echo "Gmsh no está instalado en este entorno."
    echo "Se deja la estructura lista para generar la malla manualmente."
    echo "Ubicación esperada: $SCRIPT_DIR/cavity.msh"
fi
