# Script to Install Code Saturne 
# Preparing installation and building binaries
# Tested on Zorin 17.3
# Authors: N.Torres
# jntorresr@udistrital.edu.co
# Version: 0.0.3
# Update: 18-04-2025

# Prompt the user for the URL of the latest Code Saturne tar file
read -p "Enter the URL for the latest Code Saturne tar file (go to code-saturne.org): " tar_url

# Prompt the user for the directory where they want to save and extract the tar file
read -p "Enter the directory where you want to save and extract the tar file: " target_dir

# Create the target directory if it doesn't exist
mkdir -p "$target_dir"

# Navigate to the target directory
cd "$target_dir" || { echo "Failed to navigate to $target_dir"; exit 1; }

# Download the tar file from the provided URL
wget "$tar_url" || { echo "Failed to download the file from $tar_url"; exit 1; }

# Extract the tar file
tar_file=$(basename "$tar_url")
tar -xvf "$tar_file" || { echo "Failed to extract $tar_file"; exit 1; }

# Navigate to the extracted directory
extracted_dir=$(basename "$tar_file" .tar.gz)
cd "$extracted_dir" || { echo "Failed to navigate to $extracted_dir"; exit 1; }

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y pyqt5-dev-tools python3-setuptools || { echo "Failed to install dependencies"; exit 1; }

# Create a directory for Code Saturne (optional, adjust as needed)
sudo mkdir -p /tmp/code_saturne

# Note: The following steps require Salome Meca to be installed beforehand.
# Uncomment and adjust the configuration and installation commands as needed.
# echo "Configuring Code Saturne..."
# sudo ./configure --prefix=/opt/code_saturne --with-salome=/opt/Salome/Salome-edf/Salome-V8_5_0-univ_withOT --with-hdf5=salome --with-cgns=salome --with-med=salome QT_SELECT=5 || { echo "Configuration failed"; exit 1; }

# echo "Building Code Saturne..."
# sudo make -j4 || { echo "Build failed"; exit 1; }

# echo "Installing Code Saturne..."
# sudo make install || { echo "Installation failed"; exit 1; }

echo "Script completed successfully. Follow the instructions above to configure, build, and install Code Saturne if needed."