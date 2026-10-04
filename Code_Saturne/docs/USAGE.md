# Uso de Code_Saturne

Esta guía explica el flujo mínimo para trabajar con el módulo del repositorio.

## 1. Preparación del entorno

Desde la raíz del repositorio:

```bash
cd Computational-Fluid-Dynamics/Code_Saturne
chmod +x install_code_saturne.sh code_saturne_script.sh
```

## 2. Instalación

```bash
./install_code_saturne.sh
```

Si prefieres usar el alias compatible:

```bash
./code_saturne_script.sh
```

## 3. Verificación de instalación

Tras terminar la compilación, prueba que el binario quede registrado:

```bash
source ~/.bashrc
code_saturne --help
```

Si `code_saturne` no se reconoce, revisa el contenido de `~/.bashrc` y el directorio donde quedó instalado el binario.

## 4. Estructura recomendada para un caso

```text
case_name/
├── geometry/
├── mesh/
├── setup/
├── run.sh
├── results/
└── README.md
```

## 5. Flujo típico de una simulación

1. Preparar la geometría.
2. Generar o importar la malla.
3. Definir condiciones de contorno.
4. Configurar propiedades del fluido.
5. Ejecutar el solver.
6. Revisar resultados en el directorio `results/`.

## 6. Uso del ejemplo base

El caso base de ejemplo se encuentra en:

```text
Code_Saturne/examples/cavity_case/
```

Puedes usarlo como plantilla para un caso más completo.
