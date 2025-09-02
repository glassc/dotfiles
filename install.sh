#!/bin/bash

set -e

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Create XDG directories if they don't exist with correct ownership
mkdir -p "$XDG_CACHE_HOME" && chmod 700 "$XDG_CACHE_HOME" && chown "$USER:$USER" "$XDG_CACHE_HOME"
mkdir -p "$XDG_CONFIG_HOME" && chmod 700 "$XDG_CONFIG_HOME" && chown "$USER:$USER" "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME" && chmod 755 "$XDG_DATA_HOME" && chown "$USER:$USER" "$XDG_DATA_HOME"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Link individual files from each directory to $XDG_CONFIG_HOME
for dir in "$SCRIPT_DIR"/config/*/; do
    dir_name=$(basename "$dir")
    
    target_dir="$XDG_CONFIG_HOME/$dir_name"
    
    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"
    
    # Link each file in the directory (including hidden files)
    for file in "$dir"* "$dir".*; do
        # Skip if no files match the pattern
        if [[ ! -e "$file" ]]; then
            continue
        fi
        
        # Skip directories
        if [[ -d "$file" ]]; then
            continue
        fi
        
        file_name=$(basename "$file")
        
        # Check if file has .home extension - these go to $HOME
        if [[ "$file_name" == *.home ]]; then
            # Strip .home extension and symlink to $HOME
            target_name="${file_name%.home}"
            target_file="$HOME/$target_name"
        else
            # Normal behavior - symlink to XDG_CONFIG_HOME
            target_file="$target_dir/$file_name"
        fi
        
        # Remove existing symlink or file if it exists
        if [[ -L "$target_file" ]] || [[ -f "$target_file" ]]; then
            echo "Removing existing $target_file"
            rm -f "$target_file"
        fi
        
        # Create symlink
        echo "Linking $file to $target_file"
        ln -sf "$file" "$target_file"
    done
done

ln 

echo "Installation complete!"

if [[ -n "$CODESPACES" ]]; then
    echo "In GitHub Codespaces - configs will be active in new terminals"
else
    echo "To reload your shell configuration:"
    echo "  exec zsh"
    echo "  # or restart your terminal"
fi

