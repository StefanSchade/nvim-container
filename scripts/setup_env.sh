#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

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

# Function to install necessary tools
install_tools() {
    echo "Installing black, autopep8, and MonkeyType..."
    pip install --upgrade pip
    pip install black autopep8 monkeytype
    echo "Tools installed successfully."
}

# Execute the functions
setup_python_env
install_tools

