#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Activate the virtual environment
source ~/.venv/bin/activate
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "Virtual environment activated."
else
    echo "Failed to activate virtual environment."
    exit 1
fi

# Verify that monkeytype is in PATH
which monkeytype

# Path to the MonkeyType SQLite database
MT_DB_PATH=/mnt/project/target/monkeytype.sqlite3

# Path to your source code
SRC_DIR=/workspace/src

# Verify that the MonkeyType database exists
if [ ! -f "$MT_DB_PATH" ]; then
    echo "MonkeyType type data not found at $MT_DB_PATH. Please run tests first."
    exit 1
fi

# Create a symbolic link to MonkeyType's default database path
ln -sf $MT_DB_PATH ~/.monkeytype.sqlite3

echo "Type data found. Applying annotations..."

# List modules to verify type data visibility
monkeytype list-modules

# Apply type annotations for each module found in the type data
MODULES=$(monkeytype list-modules)

if [ -z "$MODULES" ]; then
    echo "No modules found in the MonkeyType database. Ensure that type data was collected correctly."
    exit 1
fi

for MODULE in $MODULES; do
    echo "Applying annotations to module: $MODULE"
    monkeytype apply $MODULE
    
    # Optionally, format the code after applying annotations
    FILE_PATH=$(echo $MODULE | tr '.' '/').py
    if [ -f "$SRC_DIR/$FILE_PATH" ]; then
        black $SRC_DIR/$FILE_PATH
        echo "Formatted $FILE_PATH successfully."
    else
        echo "File $SRC_DIR/$FILE_PATH not found. Skipping formatting." >&2
    fi
done

echo "MonkeyType type annotations applied successfully to all modules."

