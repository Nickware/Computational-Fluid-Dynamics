# Troubleshooting de Code_Saturne

## 1. El script dice que falta una dependencia

Revisa si el sistema tiene `sudo`, `wget`, `tar` y `python3`:

```bash
which sudo wget tar python3
```

Si falta alguna, instálala antes de volver a ejecutar el script.

## 2. El binario no aparece tras la compilación

Comprueba la ruta del build y busca el ejecutable:

```bash
find "$HOME/saturne_build" -type f -name "code_saturne" 2>/dev/null
```

Si no existe, la compilación probablemente falló. Revisa los mensajes de salida del script y la carpeta del build.

## 3. `code_saturne` no se reconoce en la terminal

Ejecuta:

```bash
source ~/.bashrc
which code_saturne
```

Si sigue sin funcionar, revisa si la línea añadida por el script apareció realmente en `~/.bashrc`:

```bash
grep -n "Code_Saturne" ~/.bashrc
```

## 4. La generación del archivo `setup` falla

Esto suele pasar por una de estas causas:
- el tarball no es compatible,
- falta la estructura esperada del paquete,
- `install_saturne.py` no está donde el script lo espera.

Revisa la carpeta extraída y comprueba:

```bash
ls -la
find . -name "install_saturne.py"
```

## 5. La compilación tarda mucho o falla

Code_Saturne puede necesitar dependencias científicas y compilación paralela. Asegúrate de que el sistema está actualizado y que se instalaron las librerías requeridas. En Ubuntu/Debian esto se hace por el propio script, pero si falla, prueba:

```bash
sudo apt update
sudo apt install -y build-essential gfortran libxml2-dev zlib1g-dev python3-pyqt5 libopenmpi-dev
```

## 6. Quiero volver a ejecutar el instalador

Es recomendable borrar solo el directorio de build si quieres empezar desde cero. No elimines el directorio de fuentes si todavía te sirve como referencia.

```bash
rm -rf "$HOME/saturne_build"
```

## 7. Recomendación general

Si el problema persiste, documenta:
- la URL o tarball usado,
- el sistema operativo,
- el error exacto del compilador,
- y la carpeta de build donde falló.

Con esa información se puede aislar si el problema es de dependencias, entorno o estructura del paquete.
