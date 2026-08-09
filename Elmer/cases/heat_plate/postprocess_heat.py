#!/usr/bin/env python3
"""Postprocesado del caso de conducción térmica en una placa cuadrada.

El flujo mínimo compara la solución esperada analítica,
T(x) = 100 * (1 - x),
contra la salida numérica del caso de Elmer.

Uso:
  python3 cases/heat_plate/postprocess_heat.py --demo
  python3 cases/heat_plate/postprocess_heat.py --result-file /ruta/a/result.vtu
  python3 cases/heat_plate/postprocess_heat.py --result-file /ruta/a/result.csv
"""

from __future__ import annotations

import argparse
import csv
import math
import os
from pathlib import Path


def expected_temperature(x: float, length: float = 1.0) -> float:
    """Solución analítica para una placa con T(0)=100 y T(L)=0."""
    return 100.0 * (1.0 - x / length)


def load_csv_profile(path: Path):
    """Carga un archivo CSV con columnas x,y o x,T."""
    xs = []
    temps = []

    with path.open("r", encoding="utf-8") as f:
        reader = csv.reader(f)
        rows = list(reader)

    if not rows:
        raise ValueError(f"El archivo {path} está vacío.")

    header = [c.strip().lower() for c in rows[0]]
    if len(rows) > 1:
        data_rows = rows[1:]
    else:
        data_rows = []

    if len(header) >= 2 and all(h in header for h in ["x", "temperature"]):
        x_idx = header.index("x")
        t_idx = header.index("temperature")
        for row in data_rows:
            if len(row) <= max(x_idx, t_idx):
                continue
            xs.append(float(row[x_idx]))
            temps.append(float(row[t_idx]))
    elif len(header) >= 2 and all(h in header for h in ["x", "t"]):
        x_idx = header.index("x")
        t_idx = header.index("t")
        for row in data_rows:
            if len(row) <= max(x_idx, t_idx):
                continue
            xs.append(float(row[x_idx]))
            temps.append(float(row[t_idx]))
    elif len(rows) > 1:
        for row in rows[1:]:
            if len(row) < 2:
                continue
            xs.append(float(row[0]))
            temps.append(float(row[1]))
    else:
        raise ValueError(f"No se pudieron identificar columnas en {path}.")

    return xs, temps


def load_vtu_profile(path: Path):
    """Carga una salida VTU usando meshio si está disponible."""
    try:
        import meshio
    except ImportError as exc:
        raise RuntimeError(
            "No está instalado meshio. Instálalo con: pip install meshio"
        ) from exc

    mesh = meshio.read(path)
    points = mesh.points
    point_data = mesh.point_data

    chosen_name = None
    for candidate in ("Temperature", "temperature", "T", "temp"):
        if candidate in point_data:
            chosen_name = candidate
            break

    if chosen_name is None:
        raise ValueError(
            f"No se encontró un campo de temperatura en {path}. "
            "Prueba con nombres como Temperature, T o temperature."
        )

    values = point_data[chosen_name]
    if len(values.shape) > 1:
        values = values[:, 0]

    xs = [float(p[0]) for p in points]
    temps = [float(v) for v in values]
    return xs, temps


def build_demo_profile(points):
    """Genera una solución numérica de referencia con un pequeño ruido determinista."""
    data = []
    for x in points:
        expected = expected_temperature(x)
        noise = 0.05 * math.sin(8.0 * x) + 0.02 * math.cos(20.0 * x)
        data.append((x, expected + noise))
    return [x for x, _ in data], [t for _, t in data]


def compute_rmse(actual, expected):
    if len(actual) != len(expected):
        raise ValueError("Las longitudes de actual y esperado no coinciden.")
    if not actual:
        return 0.0
    squared = [(a - e) ** 2 for a, e in zip(actual, expected)]
    return math.sqrt(sum(squared) / len(squared))


def compare_profiles(x_actual, t_actual, x_expected=None):
    if x_expected is None:
        x_expected = sorted(set(x_actual))

    actual_by_x = {float(x): float(t) for x, t in zip(x_actual, t_actual)}
    expected_vals = [expected_temperature(float(x)) for x in x_expected]

    comparison = []
    for x in sorted(x_expected):
        actual_t = actual_by_x.get(float(x), None)
        if actual_t is None:
            actual_t = 0.0
        expected_t = expected_temperature(float(x))
        error = actual_t - expected_t
        comparison.append({
            "x": float(x),
            "expected": expected_t,
            "actual": actual_t,
            "error": error,
        })

    # RMSE sobre los valores comparables
    actual_vals = [row["actual"] for row in comparison]
    expected_vals = [row["expected"] for row in comparison]
    rmse = compute_rmse(actual_vals, expected_vals)
    return comparison, rmse


def write_csv(path: Path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["x", "expected", "actual", "error"])
        for row in rows:
            writer.writerow([
                row["x"],
                row["expected"],
                row["actual"],
                row["error"],
            ])


def resolve_result_path(case_dir: Path):
    candidates = []
    for pattern in ["*.vtu", "*.vtk", "*.csv", "*.dat"]:
        candidates.extend(case_dir.glob(pattern))

    # Prefer result-like files to the generic CSV.
    for priority in ["*.vtu", "*.vtk", "*.csv", "*.dat"]:
        matches = sorted(case_dir.glob(priority))
        if matches:
            return matches[0]
    return None


def main():
    parser = argparse.ArgumentParser(description="Postprocesa el caso de conducción térmica de Elmer.")
    parser.add_argument("--result-file", type=str, default=None)
    parser.add_argument("--demo", action="store_true")
    parser.add_argument("--output", type=str, default=None)
    args = parser.parse_args()

    case_dir = Path(__file__).resolve().parent
    if args.output is None:
        output_path = case_dir / "results" / "temperature_comparison.csv"
    else:
        output_path = Path(args.output)

    if args.demo:
        points = [i / 20.0 for i in range(21)]
        xs, temps = build_demo_profile(points)
        comparison, rmse = compare_profiles(xs, temps, x_expected=points)
        print("Modo DEMO activado.")
    else:
        result_file = Path(args.result_file) if args.result_file else resolve_result_path(case_dir)
        if result_file is None:
            raise FileNotFoundError(
                "No se encontró una salida numérica en la carpeta del caso. "
                "Usa --demo o genera un archivo .vtu/.csv antes de ejecutar el script."
            )

        try:
            if result_file.suffix.lower() == ".csv":
                xs, temps = load_csv_profile(result_file)
            else:
                xs, temps = load_vtu_profile(result_file)
        except RuntimeError as exc:
            raise RuntimeError(str(exc)) from exc

        x_eval = sorted(set(float(x) for x in xs))
        comparison, rmse = compare_profiles(xs, temps, x_expected=x_eval)
        print(f"Se comparó la solución con el archivo: {result_file}")

    write_csv(output_path, comparison)

    print("\nComparación de temperatura T(x)")
    print("x        esperado        actual          error")
    for row in comparison[:5]:
        print(f"{row['x']:.2f}    {row['expected']:.4f}      {row['actual']:.4f}      {row['error']:.4f}")

    if len(comparison) > 5:
        print("...")
        last = comparison[-1]
        print(f"{last['x']:.2f}    {last['expected']:.4f}      {last['actual']:.4f}      {last['error']:.4f}")

    print(f"\nRMSE = {rmse:.6f}")
    print(f"Reporte guardado en: {output_path}")


if __name__ == "__main__":
    main()
