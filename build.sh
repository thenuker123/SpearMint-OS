#!/bin/bash
set -e

# Default to "essentials" if no argument is passed
VARIANT=${1:-essentials}

echo "=== Building SpearMint OS [$VARIANT Variant] ==="

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
sudo apt update

echo "Step 4: Installing Mint Desktop Base..."
sudo apt install mint-meta-xfce -y

# === CONDITIONAL CONFIGURATION SPLIT ===
if [ "$VARIANT" == "essentials" ]; then
    echo "Step 5: Installing Core Essentials Only..."
    # Only the bare minimum needed for basic functionality
    sudo apt install kali-linux-core gamemode build-essential git python3-venv -y

elif [ "$VARIANT" == "ultimate" ]; then
    echo "Step 5: Installing Ultimate Full Framework Bundle..."
    # Everything! Core tools + heavy hacking suites, web browsers, and media players
    sudo apt install kali-linux-core kali-linux-default -y
    sudo apt install gamemode mesa-utils vulkan-tools steam-installer wine64 -y
    sudo apt install build-essential git python3-venv nodejs npm docker.io -y
    sudo apt install vlc gimp curl wget ufw -y
fi

echo "SpearMint Hybrid [$VARIANT] Core Built!"
