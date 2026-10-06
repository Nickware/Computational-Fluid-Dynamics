#!/usr/bin/env bash
set -Eeuo pipefail

# Wrapper compatible para la instalación de Elmer FEM.
# Redirige al instalador estandarizado en scripts/install_elmer.sh.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER="${SCRIPT_DIR}/scripts/install_elmer.sh"

if [[ ! -f "${INSTALLER}" ]]; then
    echo "ERROR: No se encontró el instalador estandarizado en ${INSTALLER}" >&2
    exit 1
fi

exec bash "${INSTALLER}" "$@"
