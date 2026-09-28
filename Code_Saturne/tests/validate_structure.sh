#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "✗ Faltan archivos requeridos: $file"
        exit 1
    fi
}

check_script_syntax() {
    local file="$1"
    bash -n "$file" || {
        echo "✗ Error de sintaxis en $file"
        exit 1
    }
}

require_file "$ROOT_DIR/README.md"
require_file "$ROOT_DIR/install_code_saturne.sh"
require_file "$ROOT_DIR/code_saturne_script.sh"
require_file "$ROOT_DIR/docs/USAGE.md"
require_file "$ROOT_DIR/docs/TROUBLESHOOTING.md"
require_file "$ROOT_DIR/docs/EXECUTION_GUIDE.md"
require_file "$ROOT_DIR/docs/RESULTS_ANALYSIS.md"
require_file "$ROOT_DIR/examples/cavity_case/README.md"
require_file "$ROOT_DIR/examples/cavity_case/case_definition.md"
require_file "$ROOT_DIR/examples/cavity_case/run_case.sh"
require_file "$ROOT_DIR/examples/cavity_case/geometry/cavity.geo"
require_file "$ROOT_DIR/examples/cavity_case/mesh/generate_mesh.sh"

check_script_syntax "$ROOT_DIR/install_code_saturne.sh"
check_script_syntax "$ROOT_DIR/code_saturne_script.sh"
check_script_syntax "$ROOT_DIR/examples/cavity_case/run_case.sh"
check_script_syntax "$ROOT_DIR/examples/cavity_case/mesh/generate_mesh.sh"

for cmd in bash wget tar python3; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "✗ Falta la herramienta requerida: $cmd"
        exit 1
    fi
done

echo "✓ Validación del módulo Code_Saturne completada correctamente."
