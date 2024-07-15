copy_config_dir() {
    local tool=$1
    local source_dir=$2
    local dest_dir=$3

    # Check if source directory exists
    if [ ! -d "$source_dir" ]; then
        echo "Error: Source directory '$source_dir' does not exist."
        exit 0
    fi

    # If the destination directory exists, ask for confirmation if SUPPRESS_WARNINGS is not set
    if [ -d "$dest_dir" ]; then
        if [ "$SUPPRESS_WARNINGS" = false ]; then
            echo "Warning: This will overwrite your existing $tool configuration in $dest_dir. Are you sure? (y/n)"
            read -p ">" choice
            case "$choice" in 
                ( y|Y ) ;;
                ( n|N ) 
                    echo "Operation cancelled."
                    exit 0
                    ;;
                ( * ) 
                    echo "Invalid input. Operation cancelled."
                    exit 1
                    ;;
            esac
        fi

        # Remove the existing destination directory
        echo "Removing existing configuration in $dest_dir"
        rm -rf "$dest_dir"
    fi

    # Copy the source directory to the destination
    echo "Copying configuration for $tool from $source_dir to $dest_dir"
    cp -r "$source_dir" "$dest_dir"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to copy '$source_dir' to '$dest_dir'."
        exit 1
    fi

    echo "$tool configuration copied to $dest_dir successfully."
}

# Example usage
# copy_config_dir "Neovim" "/path/to/source/nvim" "/path/to/destination/nvim"
