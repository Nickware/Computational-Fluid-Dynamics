#!/bin/bash

# Script to Install Code Saturne 
# Preparing installation and building binaries
# Tested on Zorin 17.3 / Ubuntu 22.04+
# Version: 0.2.0 (Fixed Build Directory & Binary Permissions)
# Update: 2026-07-05
# Authors: N.Torres

echo "=========================================="
echo "  Code_Saturne Installer v0.2.0"
echo "=========================================="
echo ""

# --- 1. Gestión del archivo fuente (Local o remoto) ---
echo "--- Code_Saturne Source Selection ---"
read -p "¿Ya tiene el archivo .tar.gz descargado localmente? (s/n): " has_file

if [[ "$has_file" =~ ^[sS]$ ]]; then
    read -p "Introducir la ruta completa al archivo .tar.gz: " local_path
    local_path=$(eval echo "$local_path") # Expande ~ si existe
    if [[ -f "$local_path" ]]; then
        tar_file_path=$(realpath "$local_path")
        tar_file=$(basename "$tar_file_path")
        # Fuentes se extraen en directorio separado del build
        target_dir=$(dirname "$tar_file_path")
        echo "✓ Usando archivo local: $tar_file"
        echo "  Directorio de fuentes: $target_dir"
    else
        echo "✗ Error: El archivo no existe en la ruta especificada."
        exit 1
    fi
else
    read -p "Introducir la URL de descarga (code-saturne.org): " tar_url
    
    # Validar URL
    if [[ ! "$tar_url" =~ ^https?:// ]]; then
        echo "✗ Error: URL inválida. Debe comenzar con http:// o https://"
        exit 1
    fi
    
    read -p "Directorio para descargar y extraer fuentes [default: $HOME/code_saturne_src]: " target_dir
    target_dir="${target_dir:-$HOME/code_saturne_src}"
    target_dir=$(realpath "$target_dir")
    mkdir -p "$target_dir"
    
    cd "$target_dir" || { echo "✗ Error: No se pudo acceder a $target_dir"; exit 1; }
    
    tar_file=$(basename "$tar_url")
    echo "Descargando $tar_file..."
    wget -O "$tar_file" "$tar_url" || { echo "✗ Descarga fallida"; exit 1; }
    tar_file_path="$target_dir/$tar_file"
    echo "✓ Archivo descargado: $tar_file"
    echo "  Directorio de fuentes: $target_dir"
fi

# --- 2. Extracción y detección ---
echo ""
echo "Extrayendo archivos..."
tar -xf "$tar_file_path"

# Detectar directorio extraído correctamente
extracted_dir=$(tar -tf "$tar_file_path" | grep -v "^$" | head -1 | cut -d"/" -f1)

if [[ -z "$extracted_dir" ]]; then
    echo "✗ Error: No se pudo detectar el directorio extraído."
    exit 1
fi

source_dir="$target_dir/$extracted_dir"

if [[ ! -d "$source_dir" ]]; then
    echo "✗ Error: Directorio extraído no encontrado: $source_dir"
    exit 1
fi

echo "✓ Fuentes extraídas en: $source_dir"

# --- 3. Dependencias del sistema ---
echo ""
echo "Instalando dependencias necesarias (requiere sudo)..."
sudo apt update
sudo apt install -y pyqt5-dev-tools python3-setuptools build-essential \
                    gfortran libxml2-dev zlib1g-dev python3-pyqt5 \
                    libopenmpi-dev || { echo "✗ Error: Fallo en instalación de dependencias"; exit 1; }

echo "✓ Dependencias instaladas correctamente"

# --- 4. Configuración del directorio de compilación (BUILD) ---
echo ""
echo "--- Configuración del Directorio de Compilación ---"
echo "Nota: El directorio BUILD debe ser SEPARADO del directorio de fuentes"
read -p "Directorio donde se COMPILARÁ Code_Saturne [default: $HOME/saturne_build]: " target_build_dir
target_build_dir="${target_build_dir:-$HOME/saturne_build}"
target_build_dir=$(realpath "$target_build_dir")

# Evitar que build esté dentro de sources
if [[ "$target_build_dir" == "$target_dir"* ]]; then
    echo "✗ Error: El directorio BUILD no puede estar dentro del directorio de fuentes."
    echo "  Por favor, seleccione un directorio SEPARADO (ej: $HOME/saturne_build)"
    exit 1
fi

mkdir -p "$target_build_dir" || { echo "✗ Error: No se pudo crear $target_build_dir"; exit 1; }
echo "✓ Directorio de compilación: $target_build_dir"

# --- 5. Instalación fase 1: Generar setup ---
echo ""
echo "=========================================="
echo "  FASE 1: Generación de Configuración"
echo "=========================================="

install_script="$source_dir/install_saturne.py"

if [[ ! -f "$install_script" ]]; then
    echo "✗ Error: install_saturne.py no encontrado en $install_script"
    exit 1
fi

cd "$target_build_dir" || { echo "✗ Error: No se pudo acceder a $target_build_dir"; exit 1; }

echo "Generando archivo de configuración 'setup'..."
python3 "$install_script" || { echo "✗ Error: Fallo en generación de setup"; exit 1; }

# --- 6. Automatización del setup ---
if [ -f "setup" ]; then
    echo "Configurando 'setup' para descarga automática de dependencias faltantes..."
    sed -i 's/download  no/download  yes/g' setup
    echo "✓ Archivo 'setup' configurado correctamente"
else
    echo "✗ Error: No se pudo generar el archivo 'setup'."
    exit 1
fi

# --- 7. Instalación fase 2: Compilación real ---
echo ""
echo "=========================================="
echo "  FASE 2: Compilación Real"
echo "=========================================="
echo "Iniciando compilación... Esto puede tardar varios minutos."

python3 "$install_script" || { 
    echo "✗ La compilación falló."
    echo "  Revisa los logs en: $target_build_dir"
    exit 1
}

echo "✓ Compilación completada con éxito"

# --- 8. Permisos y Variables del entorno ---
echo ""
echo "Configurando entorno y permisos..."

# Buscar el binario code_saturne en el directorio BUILD correcto
bin_path=$(find "$target_build_dir" -name "code_saturne" -type f -path "*/bin/*" | head -1)

if [[ -z "$bin_path" ]]; then
    # Alternativa: buscar en cualquier subdirectorio bin
    bin_path=$(find "$target_build_dir" -name "code_saturne" -type f | head -1)
fi

if [[ -z "$bin_path" ]]; then
    echo "✗ Error: No se encontró el binario code_saturne en $target_build_dir"
    echo "  Verifique los logs de compilación."
    exit 1
fi

bin_dir=$(dirname "$bin_path")

# Dar permisos de ejecución al binario
if [[ ! -x "$bin_path" ]]; then
    echo "Añadiendo permisos de ejecución al binario..."
    chmod +x "$bin_path"
    echo "✓ Permisos añadidos: $bin_path"
fi

echo "✓ Binario encontrado: $bin_path"

# Configurar ~/.bashrc
if ! grep -q "$bin_dir" ~/.bashrc; then
    echo "Exportando rutas a ~/.bashrc..."
    echo "" >> ~/.bashrc
    echo "# Code_Saturne Paths (instalado por install_saturne.sh)" >> ~/.bashrc
    echo "export PATH=\$PATH:$bin_dir" >> ~/.bashrc
    echo "alias code_saturne=\"$bin_dir/code_saturne\"" >> ~/.bashrc
    echo "✓ ~/.bashrc actualizado correctamente"
else
    echo "✗ La ruta ya existe en ~/.bashrc (no se duplicará)"
fi

# --- 9. Mensaje final ---
echo ""
echo "=========================================="
echo "  🎉 INSTALACIÓN COMPLETADA CON ÉXITO"
echo "=========================================="
echo ""
echo "Información de instalación:"
echo "  • Fuentes:        $source_dir"
echo "  • Compilación:    $target_build_dir"
echo "  • Binario:        $bin_path"
echo "  • Directorio bin: $bin_dir"
echo ""
echo "Para empezar a usar Code_Saturne:"
echo "  1. Ejecuta: source ~/.bashrc"
echo "  2. Luego:   code_saturne"
echo ""
echo "O abre una nueva terminal y usa directamente:"
echo "  code_saturne"
echo ""
echo "=========================================="