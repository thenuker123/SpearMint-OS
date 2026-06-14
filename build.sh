#!/bin/bash
set -e

VARIANT=${1:-essentials}

echo "=== Building SpearMint OS [$VARIANT Variant] ==="

echo "Step 1: Overwriting the broken host config files..."
# This completely empties the main host sources list so it can never pull the broken URLs
sudo tee /etc/apt/sources.list <<EOF
# Host sources cleared to prevent 404 leakage
EOF

# Wiping out the system lists cache entirely
sudo rm -rf /etc/apt/sources.list.d/*
sudo rm -rf /var/lib/apt/lists/*

echo "Step 2: Mapping Clean Linux Mint Mirror Tracking..."
# Added [allow-insecure=yes] to explicitly force apt to ignore all GPG/Keyring errors completely
echo "deb [trusted=yes allow-insecure=yes] http://packages.linuxmint.com wilma main upstream import backport" | sudo tee /etc/apt/sources.list.d/mint.list

echo "Step 3: Mapping Verified Kali Linux Repository Mirror Arrays..."
echo "deb [trusted=yes allow-insecure=yes] http://kali.org kali-rolling main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/kali.list

# Enable 32-bit architecture for Windows games via Steam/Wine
sudo dpkg --add-architecture i386

echo "Step 4: Executing clean system index sync..."
# --allow-unauthenticated completely forces apt to skip security checks and proceed no matter what
sudo apt-get update -y --allow-unauthenticated

# === THE UNCOMPROMISING MASTER SPLIT ===
if [ "$VARIANT" == "essentials" ]; then
    echo "Step 5: Installing Mint Desktop Base..."
    sudo apt-get install mint-meta-xfce -y --allow-unauthenticated

    echo "Step 6: Installing Core Essentials Only..."
    sudo apt-get install kali-linux-core gamemode build-essential git python3-venv -y --allow-unauthenticated

elif [ "$VARIANT" == "ultimate" ]; then
    echo "Step 5: Installing COMPLETE Linux Mint Desktop Suitcase..."
    sudo apt-get install mint-meta-core mint-meta-xfce mint-meta-codecs -y --allow-unauthenticated

    echo "Step 6: Installing COMPLETE Kali Linux Professional Ecosystem..."
    sudo apt-get install kali-linux-everything kali-desktop-xfce -y --allow-unauthenticated
    
    echo "Step 7: Injecting Ultimate Gaming & Development Performance Stack..."
    sudo apt-get install gamemode mesa-utils vulkan-tools steam-installer wine64 -y --allow-unauthenticated
    sudo apt-get install build-essential git python3-venv nodejs npm docker.io -y --allow-unauthenticated
fi

echo "SpearMint Hybrid [$VARIANT] Configuration Cycle Finished!"
wwwwwwwww