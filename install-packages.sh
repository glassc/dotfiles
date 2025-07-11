#!/bin/bash

set -e

echo "Installing packages for Debian-based systems..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Debian-based system
check_debian_based() {
    if ! command -v apt &> /dev/null; then
        print_error "This script is designed for Debian-based systems (Ubuntu, Debian, etc.)"
        print_error "APT package manager not found."
        exit 1
    fi
    print_status "Detected Debian-based system"
}

# Check if GitHub CLI is installed, install if not
install_github_cli() {
    if command -v gh &> /dev/null; then
        print_success "GitHub CLI (gh) is already installed"
        gh --version
        return 0
    fi

    print_status "GitHub CLI not found. Installing..."
    
    # Update package list
    print_status "Updating package list..."
    sudo apt update

    # Install prerequisites
    print_status "Installing prerequisites..."
    sudo apt install -y curl gnupg

    # Add GitHub CLI repository
    print_status "Adding GitHub CLI repository..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

    # Update package list and install
    print_status "Installing GitHub CLI..."
    sudo apt update
    sudo apt install -y gh

    print_success "GitHub CLI installed successfully"
    gh --version
}

# Get repository information from git remote
get_repo_info() {
    if ! git rev-parse --is-inside-work-tree &> /dev/null; then
        print_error "Not inside a git repository"
        exit 1
    fi

    # Get the remote URL and extract owner/repo
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
    
    if [[ -z "$REMOTE_URL" ]]; then
        print_error "No git remote 'origin' found"
        exit 1
    fi

    # Extract repository info from various URL formats
    if [[ "$REMOTE_URL" =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
        REPO_OWNER="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
        REPO_NAME="${REPO_NAME%.git}"  # Remove .git suffix if present
    else
        print_error "Could not parse GitHub repository from remote URL: $REMOTE_URL"
        exit 1
    fi

    print_status "Repository: $REPO_OWNER/$REPO_NAME"
}

# Download and install the latest release
install_from_release() {
    print_status "Fetching latest release information..."
    
    # Get the latest release info
    RELEASE_INFO=$(gh release view --repo "$REPO_OWNER/$REPO_NAME" --json tagName,assets)
    
    if [[ -z "$RELEASE_INFO" ]]; then
        print_error "No releases found for $REPO_OWNER/$REPO_NAME"
        exit 1
    fi

    # Extract tag name and find .deb file
    TAG_NAME=$(echo "$RELEASE_INFO" | jq -r '.tagName')
    DEB_ASSET=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | endswith(".deb")) | .name' | head -1)

    if [[ -z "$DEB_ASSET" ]]; then
        print_error "No .deb file found in the latest release ($TAG_NAME)"
        exit 1
    fi

    print_status "Found release: $TAG_NAME"
    print_status "Downloading: $DEB_ASSET"

    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT

    # Download the .deb file
    gh release download "$TAG_NAME" --repo "$REPO_OWNER/$REPO_NAME" --pattern "*.deb" --dir "$TEMP_DIR"

    # Install the package
    DEB_FILE="$TEMP_DIR/$DEB_ASSET"
    
    if [[ ! -f "$DEB_FILE" ]]; then
        print_error "Downloaded file not found: $DEB_FILE"
        exit 1
    fi

    print_status "Installing package: $DEB_ASSET"
    
    # Install the package and fix dependencies
    if sudo dpkg -i "$DEB_FILE"; then
        print_success "Package installed successfully"
    else
        print_warning "Package installation had dependency issues, fixing..."
        sudo apt-get install -f -y
        print_success "Dependencies resolved and package installed"
    fi
}

# Main execution
main() {
    print_status "Starting package installation for dotfiles..."
    
    check_debian_based
    install_github_cli
    get_repo_info
    install_from_release
    
    print_success "Package installation completed!"
    print_status "You can now run './install.sh' to set up your dotfiles configuration."
}

# Run main function
main "$@"