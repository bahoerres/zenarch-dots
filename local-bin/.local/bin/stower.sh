#!/bin/bash

# Define source and destination directories
SOURCE_DIR="$HOME/.config"
STOW_DIR="$HOME/dotfiles"
CONFIG_PKG="config"

# Create the stow package directory structure
mkdir -p "$STOW_DIR/$CONFIG_PKG/.config"

# Function to check if a path should be excluded
should_exclude() {
    local path="$1"
    # Add patterns for files/directories you want to exclude
    local exclude_patterns=(
        ".git"
        "*.log"
        "cache"
        "Cache"
        "tmp"
    )
    
    for pattern in "${exclude_patterns[@]}"; do
        if [[ "$path" == *"$pattern"* ]]; then
            return 0
        fi
    done
    return 1
}

# Function to copy files preserving directory structure
copy_config() {
    local src="$1"
    local dst="$2"
    
    find "$src" -type f -print0 | while IFS= read -r -d $'\0' file; do
        # Get relative path
        relative_path="${file#$SOURCE_DIR/}"
        
        # Check if we should exclude this file
        if should_exclude "$relative_path"; then
            echo "Skipping: $relative_path"
            continue
        fi
        
        # Create destination directory
        mkdir -p "$(dirname "$dst/.config/$relative_path")"
        
        # Copy file
        cp -v "$file" "$dst/.config/$relative_path"
    done
}

# Main execution
echo "Creating Stow package from .config directory..."
echo "Source: $SOURCE_DIR"
echo "Destination: $STOW_DIR/$CONFIG_PKG"

# Copy files
copy_config "$SOURCE_DIR" "$STOW_DIR/$CONFIG_PKG"

echo "Done! Your Stow package has been created."
echo "To use it, run: cd $STOW_DIR && stow $CONFIG_PKG"
