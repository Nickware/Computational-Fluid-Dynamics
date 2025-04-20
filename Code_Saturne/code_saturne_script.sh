# Script to Install Code Saturne 
# Preparing installation and building binaries
# Tested on Zorin 17.3
# Authors: N.Torres
# jntorresr@udistrital.edu.co
# Version: 0.0.4
# Update: 19-04-2025

# Prompt the user for the URL of the latest Code Saturne tar file
read -p "Enter the URL for the latest Code Saturne tar file (go to code-saturne.org): " tar_url
if [[ ! "$tar_url" =~ ^https?:// ]]; then
    echo "Invalid URL. Please provide a valid URL starting with http:// or https://."
    exit 1
fi

# Prompt the user for the directory where they want to save and extract the tar file
read -p "Enter the directory where you want to save and extract the tar file: " target_dir
mkdir -p "$target_dir"
cd "$target_dir" || { echo "Failed to navigate to $target_dir"; exit 1; }

# Download the tar file
wget "$tar_url" || { echo "Failed to download the file from $tar_url"; exit 1; }

# Extract the tar file
tar_file=$(basename "$tar_url")
tar -xvf "$tar_file" || { echo "Failed to extract $tar_file"; exit 1; }

# Navigate to the extracted directory
extracted_dir=$(basename "$tar_file" .tar.gz)
cd "$extracted_dir" || { echo "Failed to navigate to $extracted_dir"; exit 1; }

# Install dependencies
echo "Installing dependencies..."
if ! dpkg -l | grep -q pyqt5-dev-tools; then
    sudo apt install -y pyqt5-dev-tools python3-setuptools || { echo "Failed to install dependencies"; exit 1; }
fi

# Prompt for build directory
read -p "Enter the directory where you want to build Code Saturne (suggestion: salome_build): " target_build_dir
mkdir -p "$target_build_dir"
cd "$target_build_dir" || { echo "Failed to navigate to $target_build_dir"; exit 1; }

# Run install_saturne.py
if [[ ! -f "../target_dir/install_saturne.py" ]]; then
    echo "install_saturne.py not found in ../target_dir"
    exit 1
fi
python3 ../target_dir/install_saturne.py || { echo "Failed to run install_saturne.py"; exit 1; }

# Set environment variables
cspath="$HOME/$extracted_dir/arch/Linux_x86_64/bin"
echo "export cspath=$cspath" >> ~/.bashrc
echo "alias code_saturne=\"$cspath/code_saturne\"" >> ~/.bashrc

# Final message
echo "Script completed successfully. Run 'source ~/.bashrc' to apply the changes to your environment."