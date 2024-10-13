#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to run black
run_black() {
    echo "Running black to format Python code..."
    black /mnt/project/src --line-length 79
    black /mnt/project/tests --line-length 79
    # Alternatively, use a configuration file:
    # black /mnt/project --config /mnt/project/pyproject.toml
    echo "Black formatting completed."
}

# Function to run autopep8 (optional)
run_autopep8() {
    echo "Running autopep8 to format Python code..."
    find /mnt/project/src -type f -name "*.py" -exec autopep8 --in-place --aggressive --aggressive {} +
    echo "autopep8 formatting completed."
}

# Execute the functions
run_black
# Uncomment the next line if you prefer autopep8 over black
# run_autopep8

