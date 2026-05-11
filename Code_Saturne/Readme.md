# Code_Saturne

**Code_Saturne** es un software libre y de código abierto especializado en la **Dinámica de Fluidos Computacional (CFD)**. Desarrollado desde 1997 por la división de I+D de *Électricité de France (EDF)*, se distribuye bajo la licencia GNU GPL.

Permite simular flujos de fluidos incompresibles o compresibles, con o sin transferencia de calor y turbulencia. Incluye módulos para física avanzada como:
-   Transferencia radiativa.
-   Combustión y magnetohidrodinámica.
-   Flujos bifásicos.
-   Aplicaciones atmosféricas.

El software es multiplataforma (Linux, macOS, Windows vía WSL), escrito en **Fortran** y **C**, con herramientas de gestión en **Python** e interfaz gráfica en **PyQt**. Se integra perfectamente con herramientas como **Salome Meca** y **ParaView**.

---

# Instalador Bash para Code_Saturne

## Descripción
Este script automatiza la descarga, configuración y compilación de **Code_Saturne**. Está diseñado para superar la limitación del instalador estándar de Python, el cual se detiene tras generar el archivo de configuración. Este script gestiona las dos fases de instalación de forma continua, ideal para entornos de ingeniería y física en distribuciones derivadas de Debian/Ubuntu (probado en **Zorin OS 17.3**).

## Características
*   **Versatilidad de Fuente:** Permite descargar el código desde la URL oficial o utilizar un archivo `.tar.gz` local preexistente.
*   **Instalación de Dependencias:** Configura automáticamente el compilador (`gcc`, `gfortran`) y librerías científicas (`libxml2`, `MPI`, etc.).
*   **Automatización del Setup:** Edita dinámicamente el archivo `setup` para permitir la descarga automática de dependencias faltantes durante la compilación.
*   **Gestión de Entorno:** Configura el `PATH` y crea un `alias` en el archivo `~/.bashrc` para ejecutar el programa globalmente.

## 🛠 Requisitos
*   **Sistema:** GNU/Linux (Zorin OS, Ubuntu 22.04+ o Debian).
*   **Herramientas:** Python 3, `wget`, `tar`, `bash`.
*   **Privilegios:** Acceso a `sudo` para la instalación de paquetes del sistema.

## Uso

1.  **Asignar permisos de ejecución:**
    ```bash
    chmod +x install_saturne.sh
    

```

2. **Ejecutar el script:**
```bash
./install_saturne.sh


```



```

3.  **Configuración guiada:**
    *   Indica si el archivo fuente es local o remoto.
    *   Define las rutas de extracción y el directorio de construcción (**build**).
    *   El script realizará la Fase 1 (generación de configuración) y la Fase 2 (compilación real).

4.  **Actualizar el entorno:**
    Al finalizar, ejecuta el siguiente comando para aplicar los cambios:
    ```bash
    source ~/.bashrc
    

```

## Variables y Alias Configurados

El instalador añade las siguientes líneas a tu `~/.bashrc`:

* `export PATH=$PATH:[ruta_a_binarios]`
* `alias code_saturne="[ruta_a_binario]/code_saturne"`

## Notas Adicionales

* **Computación Paralela:** Se instala `libopenmpi-dev` por defecto para habilitar el uso de múltiples núcleos en las simulaciones.
* **Soporte de Librerías:** El script activa la opción `download yes`, permitiendo que el instalador de Code_Saturne descargue y compile automáticamente librerías como HDF5 o CGNS si no se encuentran en el sistema.
* **Depuración:** Si la compilación falla, revisa los archivos de log dentro del directorio de *build* seleccionado.

## Soporte y Referencias

* **Sitio Oficial:** [code-saturne.org](https://www.code-saturne.org)
* **Repositorios:** Gestión de versiones y código fuente.
* **Buenas Prácticas:** Script desarrollado bajo estándares de robustez y automatización para entornos académicos e industriales.

## ⚖️ Licencia

Este script se distribuye bajo términos de uso libre para propósitos educacionales y académicos. Puede ser adaptado según las necesidades específicas de investigación.

```


```