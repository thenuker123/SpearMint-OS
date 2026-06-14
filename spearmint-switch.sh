#!/bin/bash

MODE_FILE="$HOME/.config/spearmint_mode"

if [ ! -f "$MODE_FILE" ]; then
    echo "developer" > "$MODE_FILE"
fi

CURRENT_MODE=$(cat "$MODE_FILE")

if [ "$CURRENT_MODE" == "developer" ]; then
    echo "gaming" > "$MODE_FILE"
    sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
    sudo systemctl stop docker 2>/dev/null
    if command -v gamemoded &> /dev/null; then
        gamemoded -r &
    fi
    notify-send "SpearMint OS" "🚀 Gaming Mode Active! System resources optimized." --icon=multimedia-gamedev
else
    echo "developer" > "$MODE_FILE"
    sudo systemctl start docker 2>/dev/null
    sudo killall gamemoded 2>/dev/null
    notify-send "SpearMint OS" "💻 Developer Mode Active! Environment systems ready." --icon=utilities-terminal
fi
