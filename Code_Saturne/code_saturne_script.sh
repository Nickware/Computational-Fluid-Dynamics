#!/bin/bash

# Script to Install Code Saturne 
# Preparing installation and building binaries
# Tested on Zorin 17.3 / Ubuntu 22.04+
# Version: 0.1.5 (Local Source Support)
# Update: 2026-05-10

# --- 1. Gestión del archivo fuente (Local o remoto) ---
echo "--- Code_Saturne Source Selection ---"
read -p "¿Ya tiene el archivo .tar.gz descargado localmente? (s/n): " has_file

if [[ "$has_file" =~ ^[sS]$ ]]; then
    read -p "Introducir la ruta completa al archivo .tar.gz: " local_path
    local_path=$(eval echo "$local_path") # Expande ~ si existe
    if [[ -f "$local_path" ]]; then
        tar_file_path=$(realpath "$local_path")
        tar_file=$(basename "$tar_file_path")
        target_dir=$(dirname "$tar_file_path")
        echo "Usando archivo local: $tar_file"
    else
        echo "Error: El archivo no existe en la ruta especificada."
        exit 1
    fi
else
    read -p "Introducir la URL de descarga (code-saturne.org): " tar_url
    read -p "Directorio para descargar y extraer [default: $HOME/code_saturne_src]: " target_dir
    target_dir="${target_dir:-$HOME/code_saturne_src}"
    target_dir=$(realpath "$target_dir")
    mkdir -p "$target_dir"
    
    cd "$target_dir" || exit 1
    tar_file=$(basename "$tar_url")
    echo "Descargando $tar_file..."
    wget -O "$tar_file" "$tar_url" || { echo "Descarga fallida"; exit 1; }
    tar_file_path="$target_dir/$tar_file"
fi

# --- 2. Extracción y detección ---
cd "$target_dir" || exit 1
echo "Extrayendo archivos..."
tar -xf "$tar_file_path"
extracted_dir=$(tar -tf "$tar_file_path" | head -1 | cut -d"/" -f1)

# --- 3. Dependencias del sistema ---
echo "Instalando dependencias necesarias (requiere sudo)..."
sudo apt update
sudo apt install -y pyqt5-dev-tools python3-setuptools build-essential \
                    gfortran libxml2-dev zlib1g-dev python3-pyqt5 \
                    libopenmpi-dev # Recomendado para computación paralela

# --- 4. Configuración del directorio de compilación ---
read -p "Directorio donde se COMPILARÁ (build) [default: $HOME/saturne_build]: " target_build_dir
target_build_dir="${target_build_dir:-$HOME/saturne_build}"
target_build_dir=$(realpath "$target_build_dir")
mkdir -p "$target_build_dir"

# --- 5. Instalación fase 1: Generar setup ---
install_script="$target_dir/$extracted_dir/install_saturne.py"
cd "$target_build_dir" || exit 1

echo "Fase 1: Generando archivo de configuración 'setup'..."
python3 "$install_script"

# --- 6. Automatización del setup ---
if [ -f "setup" ]; then
    echo "Configurando 'setup' para descarga automática de dependencias faltantes..."
    sed -i 's/download  no/download  yes/g' setup
    # Opcional: podría añadir aquí más personalizaciones con sed si se requiere
else
    echo "Error: No se pudo generar el archivo 'setup'."
    exit 1
fi

# --- 7. Instalación fase 2: Compilación real ---
echo "Fase 2: Iniciando compilación real. Esto puede tardar varios minutos..."
python3 "$install_script" || { echo "La compilación falló. Revisa los logs en $target_build_dir"; exit 1; }

# --- 8. Variables del entorno ---
bin_path=$(find "$target_build_dir" -name "code_saturne" -type f -path "*/bin/*" | head -1)
bin_dir=$(dirname "$bin_path")

if [ -n "$bin_dir" ]; then
    if ! grep -q "$bin_dir" ~/.bashrc; then
        echo "Exportando rutas al .bashrc..."
        echo "" >> ~/.bashrc
        echo "# Code_Saturne Paths" >> ~/.bashrc
        echo "export PATH=\$PATH:$bin_dir" >> ~/.bashrc
        echo "alias code_saturne=\"$bin_dir/code_saturne\"" >> ~/.bashrc
    fi
fi

echo -e "\n¡Instalación completada con éxito!"
echo "Para empezar a usarlo, ejecutar: source ~/.bashrc"
