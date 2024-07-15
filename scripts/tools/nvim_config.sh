#!/bin/bash

SOURCE_PATH=$1
USER_HOME="/home/devuser"
DEST_PATH="$USER_HOME/.config/nvim"
NVIM_STATE="$USER_HOME/.local/state/nvim/"

# Check if the source directory exists
if [ ! -d "$SOURCE_PATH" ]; then
    echo "Error: Neovim configuration does not exist at $SOURCE_PATH"
    exit 1
else 
    echo "Neovim configuration found in folder $SOURCE_PATH."
fi

# Ensure necessary directories exist
mkdir -p "$DEST_PATH" "$NVIM_STATE"

# Copy neovim configurations
copy_configs "Neovim" "$SOURCE_PATH" "$DEST_PATH"

# Clear nvim state
rm -rf "$NVIM_STATE/*"

echo "Neovim configuration has been updated."
