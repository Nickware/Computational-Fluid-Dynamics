#!/bin/bash

# Script to Install Code Saturne 
# Preparing installation and building binaries
# Tested on Zorin 17.3
# Authors: N.Torres
# Version: 0.0.5
# Update: 19-04-2025

# Prompt the user for the URL of the latest Code Saturne tar file
read -p "Enter the URL for the latest Code Saturne tar file (go to code-saturne.org): " tar_url
if [[ ! "$tar_url" =~ ^https?:// ]]; then
    echo "Invalid URL. Please provide a valid URL starting with http:// or https://."
    exit 1
fi

# Prompt the user for the directory where they want to save and extract the tar file
read -p "Enter the directory where you want to save and extract the tar file [default: \$HOME/code_saturne_src]: " target_dir
target_dir="${target_dir:-$HOME/code_saturne_src}"
target_dir=$(realpath "$target_dir")
mkdir -p "$target_dir" || { echo "Failed to create directory $target_dir"; exit 1; }
cd "$target_dir" || { echo "Failed to navigate to $target_dir"; exit 1; }

# Download the tar file
tar_file=$(basename "$tar_url")
wget -O "$tar_file" "$tar_url" || { echo "Failed to download $tar_url"; exit 1; }

# Extract the tar file
tar -xvf "$tar_file" || { echo "Failed to extract $tar_file"; exit 1; }

# Detect the extracted directory
extracted_dir=$(tar -tf "$tar_file" | head -1 | cut -d"/" -f1)
cd "$extracted_dir" || { echo "Failed to navigate to extracted directory: $extracted_dir"; exit 1; }

# Install dependencies (basic example)
echo "Installing dependencies..."
sudo apt update
sudo apt install -y pyqt5-dev-tools python3-setuptools || { echo "Failed to install dependencies"; exit 1; }

# Prompt for build directory
read -p "Enter the directory where you want to build Code Saturne [default: \$HOME/saturne_build]: " target_build_dir
target_build_dir="${target_build_dir:-$HOME/saturne_build}"
target_build_dir=$(realpath "$target_build_dir")
mkdir -p "$target_build_dir" || { echo "Failed to create build directory $target_build_dir"; exit 1; }
cd "$target_build_dir" || { echo "Failed to navigate to $target_build_dir"; exit 1; }

# Run install_saturne.py
install_script="$target_dir/$extracted_dir/install_saturne.py"
if [[ ! -f "$install_script" ]]; then
    echo "install_saturne.py not found at $install_script"
    exit 1
fi
python3 "$install_script" || { echo "Failed to run install_saturne.py"; exit 1; }

# Set environment variables
bin_path="$HOME/code_saturne/$(basename "$extracted_dir")/arch/Linux_x86_64/bin"
echo "export PATH=\$PATH:$bin_path" >> ~/.bashrc
echo "alias code_saturne=\"$bin_path/code_saturne\"" >> ~/.bashrc

# Final message
echo ""
echo "Script completed successfully!"
echo "Run 'source ~/.bashrc' to apply the changes to your environment."
