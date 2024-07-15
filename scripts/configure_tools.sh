#!/bin/bash

# Function to log script name (assuming log_helper.sh is available and provides this function)
source /mnt/dev-env-setup/scripts/helper/log_helper.sh && log_script_name

# Disable mouse reporting at the start
echo -e "\e[?1000l"

# Check if a configuration name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <config-name>"
    exit 1
fi

CONFIG_NAME=$1
BASE_PATH="/mnt/dev-env-setup/configs/$CONFIG_NAME"
DEFAULT_PATH="/mnt/dev-env-setup/configs/default"
USER_HOME="/home/devuser"

# Check if the configuration directory exists
if [ ! -d "$BASE_PATH" ]; then
    echo "Error: Configuration '$CONFIG_NAME' does not exist at $BASE_PATH"
    exit 1
else 
    echo "Configuration '$CONFIG_NAME' found in folder $BASE_PATH."
fi

# Function to copy configurations
copy_configs() {
    local tool=$1
    local source_path=$2
    local dest_path=$3

    if [ -d "$source_path" ]; then
        echo "Warning: This will overwrite your existing $tool configuration in $dest_path. Are you sure? (y/n)"
        read -p ">" choice
        case "$choice" in 
            y|Y ) 
                rm -rf "$dest_path/*"
                cp -r "$source_path/*" "$dest_path"
                echo "$tool configuration replaced in $dest_path"
                ;;
            n|N ) 
                echo "Operation cancelled."
                exit 0
                ;;
            * ) 
                echo "Invalid input. Operation cancelled."
                exit 1
                ;;
        esac
    else
        mkdir -p "$dest_path"
        cp -r "$source_path/*" "$dest_path"
        echo "$tool configuration copied to $dest_path"
    fi
}

# Iterate over each tool in the configuration directory
for tool in $(ls $BASE_PATH); do
    TOOL_SCRIPT="/mnt/dev-env-setup/scripts/tools/${tool}_config.sh"
    if [ -f "$TOOL_SCRIPT" ]; then
        source "$TOOL_SCRIPT" "$BASE_PATH/$tool"
    else
        echo "No configuration script found for tool '$tool'. Skipping."
    fi
done

# Always copy default tmux config
cp /mnt/dev-env-setup/configs/default/tmux/tmux.conf $USER_HOME/.tmux.conf

# Ensure tmux directory exists with correct permissions
if [ ! -d /tmp/tmux-0 ]; then
    echo "Creating /tmp/tmux-0 directory"
    mkdir -p /tmp/tmux-0
fi

chown devuser:devuser /tmp/tmux-0
chmod 700 /tmp/tmux-0

# Start tmux server
tmux start-server

# Source tmux configuration
if tmux source-file $USER_HOME/.tmux.conf; then
    echo "tmux configuration sourced successfully"
else
    echo "Failed to source tmux configuration"
fi

# Manually test cloning a repository to ensure connectivity
echo "Testing git clone to ensure connectivity"
if [ -d "$USER_HOME/.local/share/nvim/lazy/catppuccin" ]; then
    echo "Directory already exists. Skipping git clone."
else
    git clone https://github.com/catppuccin/nvim.git $USER_HOME/.local/share/nvim/lazy/catppuccin
    if [ $? -ne 0 ]; then
        echo "Git clone failed. Check your network and proxy settings."
        exit 1
    else
        echo "Git clone succeeded."
    fi
fi

# Disable mouse reporting before exiting
echo -e "\e[?1000l"
