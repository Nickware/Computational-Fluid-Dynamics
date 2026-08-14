#!/usr/bin/env bash
set -Eeuo pipefail

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CASE_DIR="${ROOT_DIR}/cases/heat_plate"
EXAMPLE_DIR="${ROOT_DIR}/examples/heat_plate"

[[ -f "${CASE_DIR}/case.sif" ]] || fail "Falta el caso principal: ${CASE_DIR}/case.sif"
[[ -f "${EXAMPLE_DIR}/geometry/plate.geo" ]] || fail "Falta la geometría: ${EXAMPLE_DIR}/geometry/plate.geo"
[[ -f "${CASE_DIR}/run_case.sh" ]] || fail "Falta el ejecutable del caso: ${CASE_DIR}/run_case.sh"

grep -q "Heat Equation" "${CASE_DIR}/case.sif" || fail "El caso no contiene la ecuación de calor."
grep -q "Temperature = 100.0" "${CASE_DIR}/case.sif" || fail "Falta condición de borde caliente."
grep -q "Temperature = 0.0" "${CASE_DIR}/case.sif" || fail "Falta condición de borde frío."

echo "OK: validación del caso de conducción térmica completada."
