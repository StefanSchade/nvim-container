# Example usage
# copy_config_file "Neovim" "/path/to/source/init.vim" "/path/to/destination/init.vim"

copy_config_file() {
    local tool=$1
    local source_file=$2
    local dest_file=$3

    # Check if source file exists
    if [ ! -f "$source_file" ]; then
        echo "Error: Source file '$source_file' does not exist."
        exit 0
    fi

    # Check if destination is a file (not a directory)
    if [ -d "$dest_file" ]; then
        echo "Error: Destination '$dest_file' is a directory, not a file."
        exit 1
    fi

    # If the destination file exists, ask for confirmation if SUPPRESS_WARNINGS is not set
    if [ -f "$dest_file" ]; then
        if [ "$SUPPRESS_WARNINGS" = false ]; then
            echo "Warning: This will overwrite your existing $tool configuration in $dest_file. Are you sure? (y/n)"
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
    fi

    # Copy the source file to the destination
    cp "$source_file" "$dest_file"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to copy '$source_file' to '$dest_file'."
        exit 1
    fi

    echo "$tool configuration copied to $dest_file successfully."
}

