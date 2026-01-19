#!/bin/bash

# ComfyUI Installation Script for Manjaro Linux with NVIDIA GPU
# This script installs NVIDIA drivers, Python, and ComfyUI with all dependencies

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root for system packages
check_sudo() {
    if ! sudo -v &> /dev/null; then
        print_error "This script requires sudo privileges for installing system packages."
        exit 1
    fi
}

# Installation directory - can be changed
INSTALL_DIR="${HOME}/ComfyUI"

echo "========================================"
echo "  ComfyUI Installer for Manjaro Linux  "
echo "========================================"
echo ""

# Check for sudo access
check_sudo

# Update system
print_status "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install NVIDIA drivers using mhwd (Manjaro Hardware Detection)
print_status "Checking NVIDIA GPU and drivers..."

if lspci | grep -i nvidia &> /dev/null; then
    print_status "NVIDIA GPU detected."

    # Check if NVIDIA driver is already installed
    if ! nvidia-smi &> /dev/null; then
        print_status "Installing NVIDIA proprietary drivers..."

        # Use mhwd to auto-install the best NVIDIA driver
        sudo mhwd -a pci nonfree 0300

        print_warning "NVIDIA drivers installed. A reboot may be required."
        print_warning "If this is a fresh driver install, please reboot and run this script again."
        read -p "Continue without reboot? (y/N): " continue_choice
        if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
            echo "Please reboot and run this script again."
            exit 0
        fi
    else
        print_status "NVIDIA drivers already installed."
        nvidia-smi --query-gpu=name,driver_version --format=csv,noheader
    fi
else
    print_error "No NVIDIA GPU detected. This script is designed for NVIDIA GPUs."
    print_warning "Continuing anyway, but CUDA acceleration will not be available."
fi

# Install required system packages
print_status "Installing required system packages..."
sudo pacman -S --needed --noconfirm \
    python \
    python-pip \
    python-virtualenv \
    git \
    base-devel \
    cuda \
    cudnn

# Verify Python version
PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
print_status "Python version: $PYTHON_VERSION"

# Clone ComfyUI
print_status "Cloning ComfyUI repository..."
if [ -d "$INSTALL_DIR" ]; then
    print_warning "ComfyUI directory already exists at $INSTALL_DIR"
    read -p "Remove and reinstall? (y/N): " reinstall_choice
    if [[ "$reinstall_choice" =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_DIR"
    else
        print_status "Using existing directory..."
    fi
fi

if [ ! -d "$INSTALL_DIR" ]; then
    git clone https://github.com/Comfy-Org/ComfyUI.git "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

# Create virtual environment inside ComfyUI directory
print_status "Creating Python virtual environment..."
VENV_DIR="$INSTALL_DIR/venv"

if [ -d "$VENV_DIR" ]; then
    print_warning "Virtual environment already exists."
    read -p "Recreate virtual environment? (y/N): " recreate_venv
    if [[ "$recreate_venv" =~ ^[Yy]$ ]]; then
        rm -rf "$VENV_DIR"
        python -m venv "$VENV_DIR"
    fi
else
    python -m venv "$VENV_DIR"
fi

# Activate virtual environment
print_status "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Upgrade pip
print_status "Upgrading pip..."
pip install --upgrade pip

# Install PyTorch with CUDA support
print_status "Installing PyTorch with CUDA support..."
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124

# Install ComfyUI requirements
print_status "Installing ComfyUI requirements..."
pip install -r requirements.txt

# Verify installation
print_status "Verifying PyTorch CUDA installation..."
python -c "import torch; print(f'PyTorch version: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}')"

# Create a launcher script
print_status "Creating launcher script..."
cat > "$INSTALL_DIR/run_comfyui.sh" << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/venv/bin/activate"
python "$SCRIPT_DIR/main.py" "$@"
EOF

chmod +x "$INSTALL_DIR/run_comfyui.sh"

# Create desktop entry (optional)
print_status "Creating desktop entry..."
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/comfyui.desktop" << EOF
[Desktop Entry]
Name=ComfyUI
Comment=Stable Diffusion GUI
Exec=$INSTALL_DIR/run_comfyui.sh
Icon=applications-graphics
Terminal=true
Type=Application
Categories=Graphics;
EOF

echo ""
echo "========================================"
echo -e "${GREEN}  ComfyUI Installation Complete!${NC}"
echo "========================================"
echo ""
echo "Installation directory: $INSTALL_DIR"
echo ""
echo "To run ComfyUI:"
echo "  Option 1: $INSTALL_DIR/run_comfyui.sh"
echo "  Option 2: cd $INSTALL_DIR && source venv/bin/activate && python main.py"
echo ""
echo "ComfyUI will be available at: http://127.0.0.1:8188"
echo ""
echo "Model directories:"
echo "  - Checkpoints: $INSTALL_DIR/models/checkpoints"
echo "  - VAE: $INSTALL_DIR/models/vae"
echo "  - LoRA: $INSTALL_DIR/models/loras"
echo ""
print_warning "Remember to download and place your model files in the appropriate directories!"
echo ""
