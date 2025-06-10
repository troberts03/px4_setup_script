#!/bin/bash
set -e
echo "Updating packages..."
sudo apt update && sudo apt install -y mesa-utils git curl nano

echo "Checking OpenGL renderer..."
RENDERER=$(glxinfo | grep "OpenGL renderer" || echo "Unknown")

echo "OpenGL renderer: $RENDERER"

if echo "$RENDERER" | grep -qi "Intel"; then
    echo
    echo "Intel GPU is currently active."
    echo "This will cause issues with Gazebo and PX4 rendering."
    echo
    echo "To fix this:"
    echo 'echo "export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA" >> ~/.bashrc'
    echo "source ~/.bashrc"
    echo
    echo "Then rerun this script."
    exit 1
fi

echo "NVIDIA GPU detected — proceeding with setup..."

echo "Cloning PX4 repo..."
cd ~
git clone https://github.com/PX4/PX4-Autopilot.git --recursive

echo "Running PX4 dependency setup..."
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh

echo "🛠Building PX4 default target..."
cd ~/PX4-Autopilot
make px4_sitl

echo "PX4 build complete!"
