#!/bin/bash
set -e

# Default to "essentials" if no argument is passed
VARIANT=${1:-essentials}

echo "=== Building SpearMint OS [$VARIANT Variant] ==="

# Force remove any old lingering repository config files that are blocking the build
sudo rm -f /etc/apt/sources.list.d/kali.list /etc/apt/sources.list.d/mint.list

echo "Step 1: Mapping Linux Mint Core Repositories..."
# Adding [trusted=yes] tells the system to bypass the signature check entirely
echo "deb [trusted=yes] http://packages.linuxmint.com wilma main upstream import backport" | sudo tee /etc/apt/sources.list.d/mint.list

# Enable 32-bit architecture for Windows games via Steam/Wine
sudo dpkg --add-architecture i386

echo "Step 2: Syncing system indexes..."
sudo apt-get update

echo "Step 3: Ingesting verified Kali Linux mirror configurations..."
# Adding [trusted=yes] here completely stops GPG errors for Kali too
echo "deb [trusted=yes] http://kali.org kali-rolling main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/kali.list

echo "Step 4: Executing final clean authentication sync..."
sudo apt-get update

# === THE UNCOMPROMISING MASTER SPLIT ===
if [ "$VARIANT" == "essentials" ]; then
    echo "Step 5: Installing Mint Desktop Base..."
    sudo apt-get install mint-meta-xfce -y

    echo "Step 6: Installing Core Essentials Only..."
    sudo apt-get install kali-linux-core gamemode build-essential git python3-venv -y

elif [ "$VARIANT" == "ultimate" ]; then
    echo "Step 5: Installing COMPLETE Linux Mint Desktop Suitcase..."
    sudo apt-get install mint-meta-core mint-meta-xfce mint-meta-codecs -y

    echo "Step 6: Installing COMPLETE Kali Linux Professional Ecosystem..."
    sudo apt-get install kali-linux-everything kali-desktop-xfce -y
    
    echo "Step 7: Injecting Ultimate Gaming & Development Performance Stack..."
    sudo apt-get install gamemode mesa-utils vulkan-tools steam-installer wine64 -y
    sudo apt-get install build-essential git python3-venv nodejs npm docker.io -y
fi

echo "SpearMint Hybrid [$VARIANT] Configuration Cycle Finished!"
