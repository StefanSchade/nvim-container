#!/bin/bash


# 1. Take ownership of both mount points
sudo chown -R devuser:devuser /mnt/dev-env-setup
sudo chown -R devuser:devuser /mnt/project

# 2. Assign read/write/execute permissions to everyone (including the host user)
chmod -R 777 /mnt/dev-env-setup
chmod -R 777 /mnt/project

# 3. Set umask so that future files created by devuser will have full access to everyone
umask 000

# Log the script name
source ./helper/log_helper.sh && log_script_name

# Setup ZScaler certificate if available
source ./setup_zscaler.sh

# Execute additional setup scripts
echo "Executing setup_ssh.sh"
source ./setup_ssh.sh || { echo "Failed to execute setup_ssh.sh"; exit 1; }

# Perform tool setups
echo "Executing configure_tools.sh with -s default"
./configure_tools.sh -s default || { echo "Failed to execute configure_tools.sh"; exit 1; }

# Run the formatting script
echo "Running code formatter..."
./format_code.sh || { echo "Failed to format code."; exit 0; }

# Create a symbolic link for the scripts directory
# ln -s /mnt/dev-env-setup/scripts ~/scripts || { echo "Failed to create symbolic link"; exit 1; }


