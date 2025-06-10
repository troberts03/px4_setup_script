#!/bin/bash

set -e

echo "Updating packages"
sudo apt update && sudo apt install -y mesa-utils git curl nano

echo "Setting NVIDIA adapter fix for D3X laptops"
grep -q "MESA_D3D12_DEFAULT_ADAPTER_NAME" ~/.bashrc || echo "export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA" >> ~/.bashrc
source ~/.bashrc

echo "Applying changes..."
sleep 5

echo "Confirming GL renderer"
glxinfo | grep "OpenGL renderer"
sleep 10

echo "Cloning PX4 repo"
cd ~
git clone https://github.com/PX4/PX4-Autopilot.git --recursive

echo "Running PX4 dependency setup"
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh

echo "Building PX4 default target"
cd ~/PX4-Autopilot
make px4_sitl

echo "PX4 build complete!"
