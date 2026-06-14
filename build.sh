#!/bin/bash
set -e

VARIANT=${1:-essentials}

echo "=== Building SpearMint OS [$VARIANT Variant] ==="

echo "Step 0: DELETING HOST BACKUP LISTS..."
# Forcefully clear everything from the directory so old strings cannot leak
sudo rm -rf /etc/apt/sources.list.d/*
sudo rm -rf /var/lib/apt/lists/*

echo "Step 1: Mapping Clean Linux Mint Mirror Tracking..."
echo "deb [trusted=yes] http://packages.linuxmint.com wilma main upstream import backport" | sudo tee /etc/apt/sources.list.d/mint.list

echo "Step 2: Mapping Verified Kali Linux Repository Mirror Arrays..."
# Using http.kali.org/kali to completely bypass the broken paths
echo "deb [trusted=yes] http://kali.org kali-rolling main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/kali.list

# Enable 32-bit architecture for Windows games via Steam/Wine
sudo dpkg --add-architecture i386

echo "Step 3: Executing clean system index sync..."
sudo apt-get update -y

# === THE UNCOMPROMISING MASTER SPLIT ===
if [ "$VARIANT" == "essentials" ]; then
    echo "Step 4: Installing Mint Desktop Base..."
    sudo apt-get install mint-meta-xfce -y

    echo "Step 5: Installing Core Essentials Only..."
    sudo apt-get install kali-linux-core gamemode build-essential git python3-venv -y

elif [ "$VARIANT" == "ultimate" ]; then
    echo "Step 4: Installing COMPLETE Linux Mint Desktop Suitcase..."
    sudo apt-get install mint-meta-core mint-meta-xfce mint-meta-codecs -y

    echo "Step 5: Installing COMPLETE Kali Linux Professional Ecosystem..."
    sudo apt-get install kali-linux-everything kali-desktop-xfce -y
    
    echo "Step 6: Injecting Ultimate Gaming & Development Performance Stack..."
    sudo apt-get install gamemode mesa-utils vulkan-tools steam-installer wine64 -y
    sudo apt-get install build-essential git python3-venv nodejs npm docker.io -y
fi

echo "SpearMint Hybrid [$VARIANT] Configuration Cycle Finished!"
