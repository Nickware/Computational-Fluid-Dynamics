#!/usr/bin/env bash
set -Eeuo pipefail

CASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLE_DIR="${CASE_DIR}/../../examples/heat_plate"
MESH_DIR="${EXAMPLE_DIR}/mesh"
GEO_FILE="${EXAMPLE_DIR}/geometry/plate.geo"
MESH_FILE="${MESH_DIR}/plate.msh"

mkdir -p "${MESH_DIR}"

if command -v gmsh >/dev/null 2>&1; then
  echo "==> Generando malla con Gmsh"
  gmsh -2 "${GEO_FILE}" -o "${MESH_FILE}"
else
  echo "INFO: Gmsh no está instalado; se asume que la malla ya existe en ${MESH_FILE}"
fi

if [[ -f "${MESH_FILE}" ]]; then
  echo "==> Ejecutando caso de prueba"
  echo "Nota: requiere ElmerSolver instalado y accesible en PATH."
  echo "Comando sugerido: ElmerSolver ${CASE_DIR}/case.sif"
else
  echo "WARNING: No se encontró una malla válida en ${MESH_FILE}."
  echo "Puede generarla con Gmsh o preparar su archivo propio antes de ejecutar ElmerSolver."
fi
