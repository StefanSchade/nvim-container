#!/bin/bash

USER_HOME="/home/devuser"
SOURCE_FILE="$1/tmux.conf"
DEST_FILE="$USER_HOME/.tmux.conf"

echo "tmux config"
echo $USER_HOME
echo $SOURCE_FILE
echo $DEST_FILE

if [ "$SUPPRESS_WARNINGS" = true ]; then 
    echo "suppress warnings=true"
else
    echo "suppress warnings=false"
fi


copy_config_file "Tmux" "$SOURCE_FILE" "$DEST_FILE"
   