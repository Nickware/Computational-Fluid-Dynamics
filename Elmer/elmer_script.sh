#!/usr/bin/env bash
set -Eeuo pipefail

# Wrapper de compatibilidad.
# La versión activa del instalador está en install/install_elmer.sh.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER="${SCRIPT_DIR}/install/install_elmer.sh"

if [[ ! -f "${INSTALLER}" ]]; then
  echo "ERROR: No se encontró el instalador principal en ${INSTALLER}" >&2
  exit 1
fi

exec bash "${INSTALLER}" "$@"
