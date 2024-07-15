#!/bin/bash

SOURCE_PATH=$1
USER_HOME="/home/devuser"
DEST_PATH="$USER_HOME/.config/nvim"

echo "configure nvim"
echo $SOURCE_PATH
echo $USER_HOME
echo $DEST_PATH

if [ "$SUPPRESS_WARNINGS" = true ]; then 
    echo "suppress warnings=true"
else
    echo "suppress warnings=false"
fi

# Check if the source directory exists

copy_config_dir "Neovim" "$SOURCE_PATH" "$DEST_PATH"



