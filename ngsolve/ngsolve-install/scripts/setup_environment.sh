#!/usr/bin/env bash
# setup_environment.sh
# Configura NETGENDIR, PATH y PYTHONPATH para la instalación
# compilada desde fuente, y los añade a ~/.bashrc si no existen.

set -euo pipefail

BASEDIR="${1:-$HOME/ngsolve}"
INSTALL_DIR="${BASEDIR}/install"

if [ ! -d "${INSTALL_DIR}/bin" ]; then
    echo "ERROR: no se encontró ${INSTALL_DIR}/bin. ¿Ya corriste build_ngsolve.sh?" >&2
    exit 1
fi

PLATLIB_REL="$(python3 -c "import os.path, sysconfig; print(os.path.relpath(sysconfig.get_path('platlib'), sysconfig.get_path('data')))")"

BASHRC="${HOME}/.bashrc"
MARKER="# >>> NGSolve environment >>>"
END_MARKER="# <<< NGSolve environment <<<"

if grep -qF "${MARKER}" "${BASHRC}" 2>/dev/null; then
    echo "==> Ya existe una configuración previa de NGSolve en ${BASHRC}, se deja intacta."
else
    echo "==> Añadiendo variables de entorno a ${BASHRC}..."
    {
        echo ""
        echo "${MARKER}"
        echo "export NETGENDIR=\"${INSTALL_DIR}/bin\""
        echo "export PATH=\"\$NETGENDIR:\$PATH\""
        echo "export PYTHONPATH=\"\$NETGENDIR/../${PLATLIB_REL}\""
        echo "${END_MARKER}"
    } >> "${BASHRC}"
fi

echo "==> Listo. Ejecuta 'source ~/.bashrc' o abre una terminal nueva para aplicar los cambios."
