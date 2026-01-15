# Code Saturne

Es un programa libre y de código abierto especializado en la dinámica de fluidos computacional (CFD, por sus siglas en inglés). Fue desarrollado desde 1997 por la división de Investigación y Desarrollo de Électricité de France (EDF) y está distribuido bajo la licencia GNU General Public License​.

Code_Saturne permite simular flujos de fluidos tanto incompresibles como compresibles, con o sin transferencia de calor y turbulencia. Además, dispone de módulos dedicados para física específica como transferencia radiativa, combustión, magnetohidrodinámica, flujos bifásicos y aplicaciones atmosféricas, entre otros​.

El software es multiplataforma: funciona en Linux, Mac OS X, sistemas tipo Unix y también en Windows a través del Subsistema de Windows para Linux. Está escrito principalmente en Fortran y C, con scripts en Python y una interfaz gráfica desarrollada en PyQt​. Es compatible con una amplia variedad de formatos de malla y puede integrarse con otras herramientas de simulación como Salome Meca y ParaView para el pre y post-procesamiento de datos​.

Code_Saturne es una opción robusta y flexible para simulaciones CFD, ampliamente utilizada en investigación, industria y educación, sobre todo en proyectos que requieren herramientas libres y personalizables.

# Instalador Bash para Code_Saturne

## Descripción

Este script automatiza la descarga, instalación y configuración de Code_Saturne desde una fuente oficial dirigida por el usuario, gestionando dependencias y variables de entorno necesarias para ejecutar el software en distribuciones GNU/Linux, probado en Zorin OS 17.3. El instalador está pensado para simplificar el proceso para usuarios de ingeniería y física.

## Características

- Descargar el archivo fuente de Code_Saturne guiado por el usuario.
- Extracción y detección automática del directorio fuente.
- Instalación de dependencias mínimas vía apt (pyqt5-dev-tools, python3-setuptools).
- Construcción y compilación organizada en directorio separado.
- Configurar PATH y alias en ~/.bashrc para facilitar el acceso.
- Mensajes claros de error y éxito.


## Requisitos

- GNU/Linux (Zorin OS 17.3 recomendado, otras distribuciones derivadas de Ubuntu y Debian compatibles).
- Python 3, wget, tar, apt, bash.
- Permisos sudo para instalación de dependencias.


## Uso

1. Asignar permisos de ejecución al script:

```
chmod +x install_saturne.sh
```

2. Ejecutar el script:

```
./install_saturne.sh
```

3. Ingresar los datos solicitados:
   - URL oficial del archivo tar de Code_Saturne.
   - Directorio donde guardar y extraer los fuentes.
   - Directorio separado para la compilación.
4. Al finalizar, sigue las instrucciones para actualizar tu entorno con `source ~/.bashrc`.

## Variables configuradas

- Se añade `code_saturne` al PATH en el perfil de usuario.
- Se crea un alias `code_saturne` para ejecutar fácilmente el binario principal.


## Notas adicionales

- Si algún paso falla, revisar los mensajes en consola que especifican el código de error.
- El script instala solo dependencias mínimas; para simulaciones avanzadas, revisar la documentación oficial de Code_Saturne.
- Se puede modificar el script para agregar más dependencias o personalizar directorios según sus necesidades.


## Soporte y referencias

- Página oficial: [code-saturne.org](https://www.code-saturne.org)
- Documentación rápida: Revisar "Quick Start" en la web oficial.
- Documentación de mejores prácticas Bash: Revisar tutoriales y guías para scripts robustos.[^5][^6]


## Licencia

Este script se distribuye bajo términos de uso libre para propósito educacional y académico. Adaptable a necesidades institucionales.

***

<div style="text-align: center">⁂</div>

[^1]: https://feaforall.com/installing-salome-cfd-with-code-saturne-7-0-in-2022/

[^2]: https://qiweb.tudelft.nl/sysman/software-project-setup/project/index.html

[^3]: https://data.research.cornell.edu/data-management/sharing/writing-readmes-for-research-code-software/

[^4]: https://ecommons.cornell.edu/items/version/433

[^5]: https://www.hostmycode.in/tutorials/best-practices-for-writing-bash-scripts

[^6]: https://sharats.me/posts/shell-script-best-practices/
