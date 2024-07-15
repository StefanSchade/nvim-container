#!/bin/bash

# Source and call helper script
source /mnt/dev-env-setup/scripts/helper/log_helper.sh && log_script_name

# Check for and set up Zscaler certificate
source /mnt/dev-env-setup/scripts/setup_zscaler.sh

# Execute additional setup scripts
echo "Executing setup_ssh.sh"
source /mnt/dev-env-setup/scripts/setup_ssh.sh || { echo "Failed to execute setup_ssh.sh"; exit 1; }

# Any other setup tasks can be added here
