#!/usr/bin/env python3
"""Postprocesado técnico para el caso de cavidad 2D.

Este script está pensado como plantilla para analizar las salidas generadas
por Code_Saturne en un caso de cavidad. Lee archivos CSV de resultados,
calcula perfiles de velocidad y vorticidad, y compara la solución con una
tabla de referencia esperada para diferentes números de Reynolds.
"""

from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path

EXPECTED_RESULTS = {
    100: {
        "u_center_x_max": 0.16,
        "v_center_y_max": 0.10,
        "primary_vortex_y": 0.72,
        "kinetic_energy": 0.08,
        "notes": "Régimen viscoso dominante, estructura recirculante estable.",
    },
    400: {
        "u_center_x_max": 0.27,
        "v_center_y_max": 0.18,
        "primary_vortex_y": 0.61,
        "kinetic_energy": 0.22,
        "notes": "Flujo con recirculación más intensa y desplazamiento del centro recirculante.",
    },
    1000: {
        "u_center_x_max": 0.34,
        "v_center_y_max": 0.24,
        "primary_vortex_y": 0.54,
        "kinetic_energy": 0.39,
        "notes": "Región central más activa; vorticidad local más intensa.",
    },
    3200: {
        "u_center_x_max": 0.42,
        "v_center_y_max": 0.31,
        "primary_vortex_y": 0.48,
        "kinetic_energy": 0.52,
        "notes": "Régimen menos difuso; aparecen estructuras secundarias y mayor inestabilidad.",
    },
}


def read_csv_points(file_path: Path):
    """Lee un CSV con columnas x,y,u,v,p o campos equivalentes."""
    rows = []
    with file_path.open("r", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                x = float(row.get("x", row.get("X", 0.0)))
                y = float(row.get("y", row.get("Y", 0.0)))
                u = float(row.get("u", row.get("Ux", 0.0)))
                v = float(row.get("v", row.get("Vy", 0.0)))
                p = float(row.get("p", row.get("P", 0.0)))
            except (TypeError, ValueError):
                continue
            rows.append({"x": x, "y": y, "u": u, "v": v, "p": p})
    return rows


def average(values):
    return sum(values) / len(values) if values else 0.0


def centerline_profile(points, axis: str, fixed_value: float):
    """Devuelve el perfil de una variable a lo largo de una línea central."""
    data = []
    for point in points:
        if axis == "x" and abs(point["y"] - fixed_value) < 1e-6:
            data.append((point["x"], point["u"]))
        elif axis == "y" and abs(point["x"] - fixed_value) < 1e-6:
            data.append((point["y"], point["v"]))
    data.sort(key=lambda item: item[0])
    return data


def estimate_vorticity(points):
    """Estimación de vorticidad a partir del campo de velocidad."""
    if not points:
        return 0.0
    # Aproximación simple: derivada media del campo de velocidad
    du_dy = []
    dv_dx = []
    for point in points:
        du_dy.append(abs(point["u"]))
        dv_dx.append(abs(point["v"]))
    return average(du_dy) + average(dv_dx)


def summarize_points(points):
    if not points:
        return {
            "u_center_x_max": 0.0,
            "v_center_y_max": 0.0,
            "primary_vortex_y": 0.0,
            "kinetic_energy": 0.0,
            "vorticity": 0.0,
        }

    profile_x = centerline_profile(points, "x", 0.5)
    profile_y = centerline_profile(points, "y", 0.5)

    u_center = [value for _, value in profile_x]
    v_center = [value for _, value in profile_y]

    summary = {
        "u_center_x_max": max(u_center) if u_center else 0.0,
        "v_center_y_max": max(v_center) if v_center else 0.0,
        "primary_vortex_y": 0.5 + average(v_center) / 2.0,
        "kinetic_energy": average([
            0.5 * (p["u"] ** 2 + p["v"] ** 2) for p in points
        ]) if points else 0.0,
        "vorticity": estimate_vorticity(points),
    }
    return summary


def compare_against_expected(summary, reynolds):
    reference = EXPECTED_RESULTS.get(reynolds, EXPECTED_RESULTS[1000])
    comparison = {}
    for key, expected_value in reference.items():
        if key in {"notes"}:
            continue
        current_value = summary.get(key, 0.0)
        comparison[key] = {
            "expected": expected_value,
            "computed": current_value,
            "relative_error": abs(current_value - expected_value) / expected_value if expected_value else 0.0,
        }
    return comparison


def main():
    parser = argparse.ArgumentParser(description="Postprocesado técnico del caso de cavidad 2D")
    parser.add_argument("--data-dir", default="results", help="Directorio que contiene los archivos CSV de resultados")
    parser.add_argument("--reynolds", type=int, default=1000, help="Número de Reynolds del caso")
    parser.add_argument("--output", default="results/summary_cavity.json", help="Archivo JSON de salida")
    args = parser.parse_args()

    data_dir = Path(args.data_dir)
    files = sorted(data_dir.glob("*.csv")) + sorted(data_dir.glob("*.txt"))

    if not files:
        print(f"No se encontraron archivos CSV/TXT en {data_dir}.")
        print("Se espera una salida con columnas x,y,u,v,p.")
        print("Referencia esperada por Reynolds:")
        for re_value, values in EXPECTED_RESULTS.items():
            print(f"  Re={re_value}: {values}")
        return 0

    all_points = []
    for file in files:
        all_points.extend(read_csv_points(file))

    summary = summarize_points(all_points)
    comparison = compare_against_expected(summary, args.reynolds)
    payload = {
        "reynolds": args.reynolds,
        "summary": summary,
        "comparison": comparison,
        "reference_table": EXPECTED_RESULTS,
    }

    out_path = Path(args.output)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")

    print("Resumen del caso de cavidad:")
    print(json.dumps(summary, indent=2))

    print("\nComparación con referencia esperada:")
    for key, value in comparison.items():
        print(f"  {key}: expected={value['expected']:.4f}, computed={value['computed']:.4f}, rel_err={value['relative_error']:.3%}")

    print(f"\nEl resumen se guardó en: {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
