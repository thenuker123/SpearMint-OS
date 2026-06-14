#!/bin/bash
set -e

# Default to "essentials" if no argument is passed
VARIANT=${1:-essentials}

echo "=== Building SpearMint OS [$VARIANT Variant] ==="

# Clean out any old broken configurations
sudo rm -f /etc/apt/sources.list.d/kali.list /etc/apt/sources.list.d/mint.list

echo "Step 1: Safely Injecting Linux Mint Keyring & Repositories..."
sudo mkdir -p /etc/apt/keyrings

# 1. Download the raw armored ASCII key from the Ubuntu keyserver keyspool
wget -qO- "https://ubuntu.com" > mint-key.asc

# 2. De-armor the text key into a compiled binary .gpg layout that APT accepts
sudo gpg --dearmor -o /etc/apt/keyrings/linuxmint-keyring.gpg < mint-key.asc
rm -f mint-key.asc

# 3. Add the Mint repository linked cleanly to that new signed key
echo "deb [signed-by=/etc/apt/keyrings/linuxmint-keyring.gpg] http://packages.linuxmint.com wilma main upstream import backport" | sudo tee /etc/apt/sources.list.d/mint.list

# Enable 32-bit architecture for Windows games via Steam/Wine
sudo dpkg --add-architecture i386

echo "Step 2: Syncing system indexes..."
sudo apt update && sudo apt upgrade -y

echo "Step 3: Fetching Pre-compiled Kali Security Keyrings..."
sudo wget -q https://kali.org -O /usr/share/keyrings/kali-archive-keyring.gpg

echo "Step 3b: Ingesting verified Kali Linux mirror configurations..."
echo "deb [signed-by=/usr/share/keyrings/kali-archive-keyring.gpg] http://kali.org kali-rolling main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/kali.list

echo "Step 4: Executing full system authentication sync..."
sudo apt update

# === THE UNCOMPROMISING MASTER SPLIT ===
if [ "$VARIANT" == "essentials" ]; then
    echo "Step 5: Installing Mint Desktop Base..."
    sudo apt install mint-meta-xfce -y

    echo "Step 6: Installing Core Essentials Only..."
    sudo apt install kali-linux-core gamemode build-essential git python3-venv -y

elif [ "$VARIANT" == "ultimate" ]; then
    echo "Step 5: Installing COMPLETE Linux Mint Desktop Suitcase..."
    sudo apt install mint-meta-core mint-meta-xfce mint-meta-codecs -y

    echo "Step 6: Installing COMPLETE Kali Linux Professional Ecosystem..."
    sudo apt install kali-linux-everything kali-desktop-xfce -y
    
    echo "Step 7: Injecting Ultimate Gaming & Development Performance Stack..."
    sudo apt install gamemode mesa-utils vulkan-tools steam-installer wine64 -y
    sudo apt install build-essential git python3-venv nodejs npm docker.io -y
fi

echo "SpearMint Hybrid [$VARIANT] Configuration Cycle Finished!"
