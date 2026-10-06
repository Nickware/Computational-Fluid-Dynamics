# Troubleshooting de Elmer FEM

## 1. `sudo: command not found`

Si el sistema no tiene `sudo`, el instalador se ejecutará sin él. En algunos entornos no es necesario usar sudo si el usuario tiene permisos de escritura en `/opt`.

## 2. `apt-get: command not found`

El instalador está pensado para Debian/Ubuntu. Si usas otra distribución, instala las dependencias manualmente equivalente al script.

## 3. Faltan `gfortran`, `gcc`, `g++` o `cmake`

Ejecuta:

```bash
sudo apt-get install -y build-essential gfortran cmake git
```

## 4. `git clone` falla

Comprueba conexión a Internet y que la URL del repositorio está disponible.

## 5. Elmer no aparece en PATH

Revisa si el bloque de entorno se añadió a `~/.bashrc`:

```bash
grep -n "ELMER_HOME" ~/.bashrc
```

Luego recarga:

```bash
source ~/.bashrc
```

## 6. Error al compilar con CMake

Comprueba que todas las dependencias están instaladas y que el directorio de compilación no está corrupto:

```bash
rm -rf /tmp/elmer-build
```

## 7. ElmerGUI no inicia

Suele deberse a paquetes Qt faltantes o a una instalación parcial. Reinstala las dependencias Qt5 y vuelve a intentar.
