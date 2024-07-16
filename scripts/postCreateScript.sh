#!/bin/bash

# Log the script name
source /mnt/dev-env-setup/scripts/helper/log_helper.sh && log_script_name

# Setup ZScaler certificate if available
source /mnt/dev-env-setup/scripts/setup_zscaler.sh

# Execute additional setup scripts
echo "Executing setup_ssh.sh"
source /mnt/dev-env-setup/scripts/setup_ssh.sh || { echo "Failed to execute setup_ssh.sh"; exit 1; }

# Perform tool setups
echo "Executing configure_tools.sh with -s default"
/mnt/dev-env-setup/scripts/configure_tools.sh -s default || { echo "Failed to execute configure_tools.sh"; exit 1; }

# Create a symbolic link for the scripts directory
ln -s /mnt/dev-env-setup/scripts ~/scripts || { echo "Failed to create symbolic link"; exit 1; }
