#!/usr/bin/env python3
"""
test_ngsolve.py

Test mínimo de validación de instalación de NGSolve.

Resuelve la ecuación de Poisson -Δu = f en un cuadrado unitario con
condiciones de Dirichlet homogéneas, y compara la energía de la
solución contra un valor de referencia conocido. Si NGSolve está
correctamente instalado (mallado con Netgen + ensamblaje + solver
lineal funcionando), este script debe correr sin errores y reportar
"INSTALACION OK".
"""

import sys

def main():
    try:
        from ngsolve import (
            Mesh, H1, GridFunction, BilinearForm, LinearForm,
            grad, dx, CoefficientFunction
        )
        from netgen.geom2d import unit_square
    except ImportError as exc:
        print(f"ERROR: no se pudo importar NGSolve/Netgen: {exc}")
        print("Revisa que NETGENDIR y PYTHONPATH estén configurados (instalación")
        print("desde fuente) o que el entorno pip correcto esté activo.")
        sys.exit(1)

    print("==> NGSolve importado correctamente.")

    # 1. Generar malla del cuadrado unitario
    mesh = Mesh(unit_square.GenerateMesh(maxh=0.2))
    print(f"==> Malla generada: {mesh.ne} elementos, {mesh.nv} vertices.")

    # 2. Espacio de elementos finitos H1, orden 2, Dirichlet en todo el borde
    fes = H1(mesh, order=2, dirichlet=".*")
    u, v = fes.TnT()

    # 3. Forma bilineal (rigidez) y forma lineal (fuente f = 1)
    a = BilinearForm(fes)
    a += grad(u) * grad(v) * dx
    a.Assemble()

    f = LinearForm(fes)
    f += CoefficientFunction(1) * v * dx
    f.Assemble()

    # 4. Resolver el sistema lineal
    gfu = GridFunction(fes)
    gfu.vec.data = a.mat.Inverse(fes.FreeDofs()) * f.vec

    # 5. Verificar contra un valor de referencia conocido
    #    Para -Δu=1 en el cuadrado unitario con u=0 en el borde,
    #    el valor máximo de u es aprox. 0.0736713 (dato de referencia).
    max_u = max(gfu.vec.FV().NumPy())
    referencia = 0.0736713
    tolerancia = 0.01

    print(f"==> Valor maximo calculado de u: {max_u:.6f}")
    print(f"==> Valor de referencia esperado: {referencia:.6f}")

    if abs(max_u - referencia) < tolerancia:
        print("\n>>> INSTALACION OK: la solucion coincide con el valor de referencia.")
        sys.exit(0)
    else:
        print("\n>>> ADVERTENCIA: la solucion se aleja del valor de referencia.")
        print("    NGSolve corrio, pero revisa la version o el resultado numerico.")
        sys.exit(2)


if __name__ == "__main__":
    main()
