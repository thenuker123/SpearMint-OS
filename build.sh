#!/bin/bash
set -e

echo "Step 1: Fetching Linux Mint's Core Package Repositories..."
sudo apt-get install linuxmint-keyring -y
echo "deb http://linuxmint.com wilma main upstream import backport" | sudo tee /etc/apt/sources.list.d/mint.list

# Enable 32-bit architecture for Windows games via Steam/Wine
sudo dpkg --add-architecture i386

echo "Step 2: Syncing system indexes..."
sudo apt update && sudo apt upgrade -y

echo "Step 3: Injecting Kali Linux Cyber Security Repositories..."
sudo wget -q -O - https://kali.org | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/kali-archive-keyring.gpg > /dev/null
echo "deb http://kali.org kali-rolling main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/kali.list

echo "Step 4: Final sync of the new dual-repo database..."
sudo apt update

echo "Step 5: Installing Mint's Desktop Environment + Kali Core Packages..."
sudo apt install mint-meta-xfce kali-linux-core -y

echo "Step 6: Installing Performance Gaming Essentials..."
sudo apt install gamemode mesa-utils vulkan-tools steam-installer wine64 -y

echo "Step 7: Installing Core Development Engines..."
sudo apt install build-essential git python3-venv nodejs npm docker.io -y

echo "SpearMint Hybrid Core Built!"
