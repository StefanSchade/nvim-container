#!/bin/bash

source /mnt/dev-env-setup/scripts/helper/log_helper.sh && log_script_name

# Disable mouse reporting at the start
echo -e "\e[?1000l"

source ./tools/copy_config_dir.sh
source ./tools/copy_config_file.sh

# Check for suppress warnings option
while getopts ":s" opt; do
  case ${opt} in
    ( s ) 
      SUPPRESS_WARNINGS=true
      ;;
    ( \? ) 
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Check if a configuration name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <config-name>"
    exit 1
fi

CONFIG_NAME=$1
BASE_PATH="/mnt/dev-env-setup/configs/$CONFIG_NAME"
USER_HOME="/home/devuser"

# Check if the configuration directory exists
if [ ! -d "$BASE_PATH" ]; then
    echo "Error: Configuration '$CONFIG_NAME' does not exist at $BASE_PATH"
    exit 1
else 
    echo "Configuration '$CONFIG_NAME' found in folder $BASE_PATH."
fi

# Iterate over each tool in the configuration directory
for tool in $(ls $BASE_PATH); do
    TOOL_SCRIPT="/mnt/dev-env-setup/scripts/tools/configure_${tool}.sh"
    if [ -f "$TOOL_SCRIPT" ]; then
        echo "Configuring $TOOL_SCRIPT path $BASE_PATH/$tool"
        source "$TOOL_SCRIPT" "$BASE_PATH/$tool"
    else
        echo "No configuration script found for tool '$tool'. Skipping."
    fi
done

# Disable mouse reporting before exiting
echo -e "\e[?1000l"
