#!/bin/bash

SOURCE_PATH=$1
USER_HOME="/home/devuser"
DEST_PATH="$USER_HOME/.tmux.conf"

# Check if the source file exists
if [ ! -f "$SOURCE_PATH/tmux.conf" ]; then
    echo "Error: Tmux configuration does not exist at $SOURCE_PATH/tmux.conf"
    exit 1
else 
    echo "Tmux configuration found in folder $SOURCE_PATH."
fi

# Copy tmux configuration
cp "$SOURCE_PATH/tmux.conf" "$DEST_PATH"

echo "Tmux configuration has been updated."
