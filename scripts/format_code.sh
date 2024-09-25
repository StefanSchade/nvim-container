#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to check if Python files exist
has_python_files() {
    find /mnt/project/src -type f -name "*.py" | read
}

# Function to set up Python virtual environment
setup_python_env() {
    if [ -d "/home/devuser/.venv" ]; then
        # Check if the activate script exists
        if [ -f "/home/devuser/.venv/bin/activate" ]; then
            echo "Python virtual environment already exists and is valid."
            source /home/devuser/.venv/bin/activate
            return
        else
            echo "Virtual environment directory exists but is invalid. Removing..."
            rm -rf /home/devuser/.venv
        fi
    fi

    echo "Creating Python virtual environment..."
    python3 -m venv /home/devuser/.venv || { echo "Failed to create virtual environment."; exit 1; }
    echo "Virtual environment created at /home/devuser/.venv"
    source /home/devuser/.venv/bin/activate
}

# Function to install formatting tools
install_formatters() {
    echo "Installing black and autopep8..."
    pip install --upgrade pip
    pip install black autopep8
    echo "Formatters installed successfully."
}

# Function to run black
run_black() {
    echo "Running black to format Python code..."
    black /mnt/project/src --line-length 78
    black /mnt/project/tests --line-length 78
    # black /mnt/project --config /mnt/project/pyproject.toml
    echo "Black formatting completed."
}

# Function to run autopep8
run_autopep8() {
    echo "Running autopep8 to format Python code..."
    find /mnt/project/src -type f -name "*.py" -exec autopep8 --in-place --aggressive --aggressive {} +
    echo "autopep8 formatting completed."
}

# Main Execution Flow
if has_python_files; then
    echo "Python files detected. Setting up formatting environment..."
    setup_python_env
    install_formatters
    
    # Choose which formatter to run
    # Uncomment the one you prefer

    run_black
    # run_autopep8

    echo "Code formatting completed successfully."
else
    echo "No Python files found in /mnt/project/src. Skipping formatting."
fi

