# Code_Saturne

**Code_Saturne** es un software libre y de código abierto especializado en **Dinámica de Fluidos Computacional (CFD)**. Desarrollado desde 1997 por la división de I+D de *Électricité de France (EDF)*, se distribuye bajo la licencia GNU GPL.

Permite simular flujos de fluidos incompresibles o compresibles, con o sin transferencia de calor y turbulencia. Incluye módulos para física avanzada como:

- Transferencia radiativa  
- Combustión y magnetohidrodinámica  
- Flujos bifásicos  
- Aplicaciones atmosféricas  

El software es multiplataforma (Linux, macOS, Windows vía WSL), escrito en **Fortran** y **C**, con herramientas de gestión en **Python** e interfaz gráfica en **PyQt**. Se integra perfectamente con herramientas como **Salome Meca** y **ParaView**.

***

# Instalador Bash para Code_Saturne (v0.1.5)

## Descripción

Este script automatiza la **descarga (o uso de fuente local)**, configuración y compilación de **Code_Saturne**. Supera la limitación del instalador estándar de Python, el cual se detiene tras generar el archivo `setup`. El script gestiona de forma continua las **dos fases de instalación**:

1. Generación del archivo de configuración `setup`.
2. Compilación real con descarga automática de dependencias faltantes.

Está optimizado para entornos de ingeniería y física en distribuciones derivadas de **Debian/Ubuntu**, probado en **Zorin OS 17.3** y **Ubuntu 22.04+**.

## Características

- **Fuente flexible:** Permite usar un archivo `.tar.gz` **local** o descargarlo desde la **URL oficial**.
- **Dependencias completas:** Instala automáticamente compiladores (`gcc`, `gfortran`) y librerías científicas (`libxml2`, `zlib`, `MPI`, `PyQt5`).
- **Automatización del `setup`:** Modifica dinámicamente el archivo `setup` activando `download yes` para descargar dependencias faltantes (HDF5, CGNS, etc.).
- **Gestión de entorno:** Detecta automáticamente la ruta del binario y configura `PATH` + `alias code_saturne` en `~/.bashrc`.
- **Soporte para compilación paralela:** Incluye `libopenmpi-dev` por defecto.

## Requisitos

| Requerimiento       | Detalle                                      |
|---------------------|----------------------------------------------|
| Sistema operativo   | GNU/Linux (Zorin OS, Ubuntu 22.04+, Debian) |
| Python              | 3.x                                          |
| Herramientas        | `wget`, `tar`, `bash`, `sudo`               |
| Permisos            | Acceso `sudo` para instalar paquetes        |

## Uso

### 1. Asignar permisos de ejecución

```bash
chmod +x install_saturne.sh
```

### 2. Ejecutar el script

```bash
./install_saturne.sh
```

### 3. Configuración guiada

El script te guiará paso a paso:

1. **¿Ya tienes el archivo .tar.gz localmente?**  
   - Si responde **s**: ingresar la ruta completa al archivo.  
   - Si responde **n**: ingresar la URL oficial y el directorio de descarga.
2. **Directorio de extracción** (por defecto: `$HOME/code_saturne_src`)
3. **Directorio de compilación (build)** (por defecto: `$HOME/saturne_build`)

El script ejecutará automáticamente:

- **Fase 1:** Generación del archivo `setup`
- **Fase 2:** Compilación real con dependencias auto-descargadas

### 4. Actualizar el entorno

Al finalizar, aplica los cambios ejecutando:

```bash
source ~/.bashrc
```

Luego puede ejecutar Code_Saturne con:

```bash
code_saturne
```

## Variables y Alias Configurados

El instalador agrega automáticamente al `~/.bashrc`:

```bash
# Code_Saturne Paths
export PATH=$PATH:/ruta/a/binarios
alias code_saturne="/ruta/a/binarios/code_saturne"
```

La ruta se detecta dinámicamente buscando `code_saturne` dentro de `*/bin/*` en el directorio de build.

## Notas Adicionales

- **Computación paralela:** `libopenmpi-dev` está incluido por defecto para ejecutar simulaciones multinúcleo.
- **Librerías científicas:** Al activar `download yes`, Code_Saturne descarga y compila automáticamente HDF5, CGNS y otras si no están en el sistema.
- **Depuración:** Si la compilación falla, revisa los logs en el directorio de build seleccionado.
- **Reanudabilidad:** El script es seguro para reejecutar si se interrumpe, siempre que no se borre el directorio de build.

## Soporte y Referencias

- **Sitio oficial:** [code-saturne.org](https://www.code-saturne.org)
- **Documentación rápida:** Sección *Quick Start* en la web oficial
- **Herramientas complementarias:** [Salome Meca](https://www.salome-meca.fr), [ParaView](https://www.paraview.org)

## Licencia

Este script se distribuye bajo términos de uso libre para propósitos **educacionales y académicos**. Puede ser adaptado según necesidades específicas de investigación o industria.
