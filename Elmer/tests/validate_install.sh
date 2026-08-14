#!/usr/bin/env bash
set -Eeuo pipefail

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

info() {
  echo "INFO: $*"
}

check_command() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || fail "No se encontró '$cmd' en PATH."
}

require_env_path() {
  local expected_dir="${1:-}"
  if [[ -n "$expected_dir" ]]; then
    [[ -d "$expected_dir" ]] || fail "ELMER_HOME apunta a un directorio inexistente: $expected_dir"
    [[ -x "$expected_dir/bin/ElmerSolver" ]] || fail "No se encontró ElmerSolver en $expected_dir/bin"
    [[ -x "$expected_dir/bin/ElmerGrid" ]] || fail "No se encontró ElmerGrid en $expected_dir/bin"
  fi
}

echo "==> Validación mínima de instalación de Elmer FEM"
check_command git
check_command cmake
check_command make
check_command gcc
check_command g++
check_command gfortran

if [[ -n "${ELMER_HOME:-}" ]]; then
  require_env_path "${ELMER_HOME}"
else
  info "ELMER_HOME no está definido; se verificará el PATH actual."
fi

check_command ElmerSolver
check_command ElmerGrid

ElmerSolver -h >/dev/null 2>&1 || fail "ElmerSolver no está funcionando correctamente."
ElmerGrid -h >/dev/null 2>&1 || fail "ElmerGrid no está funcionando correctamente."

echo "OK: validación mínima completada. El entorno de Elmer parece operativo."
