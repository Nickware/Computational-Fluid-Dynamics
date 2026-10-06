#!/usr/bin/env bash
set -Eeuo pipefail

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

check_command() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || fail "No se encontró '$cmd' en PATH."
}

echo "==> Validación de instalación de Elmer FEM"
check_command git
check_command cmake
check_command make
check_command gcc
check_command g++
check_command gfortran

if [[ -n "${ELMER_HOME:-}" ]]; then
  test -d "${ELMER_HOME}" || fail "ELMER_HOME apunta a un directorio inexistente: ${ELMER_HOME}"
fi

check_command ElmerSolver || echo "INFO: ElmerSolver no está en PATH; el entorno puede no estar recargado."
check_command ElmerGrid || echo "INFO: ElmerGrid no está en PATH; el entorno puede no estar recargado."

echo "OK: Validación de la instalación básica completada."
