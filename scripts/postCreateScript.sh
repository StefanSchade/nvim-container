#!/bin/bash

# Log the script name
source ./helper/log_helper.sh && log_script_name

# echo "XXXXXXXXXXXXXXX"
# ls -l /home/devuser/
# echo "XXXXXXXXXXXXXXX"
# echo "scripts before conversion:"
# cat /home/devuser/before_dos2unix.txt
# echo "XXXXXXXXXXXXXXX"
# echo "scripts after conversion:"
# cat /home/devuser/after_dos2unix.txt
# echo "XXXXXXXXXXXXXXX"

# Setup ZScaler certificate if available
source ./setup_zscaler.sh

# Execute additional setup scripts
echo "Executing setup_ssh.sh"
source ./setup_ssh.sh || { echo "Failed to execute setup_ssh.sh"; exit 1; }

# Perform tool setups
echo "Executing configure_tools.sh with -s default"
ls -l /home/devuser/scripts_setup_env/configure_tools.sh
#./configure_tools.sh -s default || { echo "Failed to execute configure_tools.sh"; exit 1; }
./configure_tools.sh -s default || { echo "Failed to execute configure_tools.sh"; exit 1; }

# Create a symbolic link for the scripts directory
# ln -s /mnt/dev-env-setup/scripts ~/scripts || { echo "Failed to create symbolic link"; exit 1; }